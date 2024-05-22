use std::{collections::HashMap, future::Future, time::Duration};

use temporal_client::{
    ClientInitError, ClientKeepAliveConfig as CoreClientKeepAliveConfig, ClientOptions,
    ClientOptionsBuilder, ConfiguredClient, HealthService, HttpConnectProxyOptions,
    OperatorService, RetryClient, RetryConfig, TemporalServiceClientWithMetrics, TestService,
    TlsConfig, WorkflowService,
};

use magnus::{
    block::Proc, class, function, gc, method, prelude::*, scan_args, typed_data::Obj,
    value::Opaque, Attr, DataTypeFunctions, Error, Integer, RString, Ruby, TypedData, Value,
};
use tonic::{metadata::MetadataKey, Status};
use url::Url;

use super::{error, new_error, ROOT_MOD};
use crate::runtime::{Runtime, RuntimeHandle};
use std::str::FromStr;

pub fn init(ruby: &Ruby) -> Result<(), Error> {
    let root_mod = ruby.get_inner(&ROOT_MOD);

    let class = root_mod.define_class("Client", class::object())?;
    class.define_singleton_method("new", function!(Client::new, -1))?;
    class.define_method(
        "call_workflow_service",
        method!(Client::call_workflow_service, -1),
    )?;

    let inner_class = class.define_class("RpcFailure", class::object())?;
    inner_class.define_method("code", method!(RpcFailure::code, 0))?;
    inner_class.define_method("message", method!(RpcFailure::message, 0))?;
    inner_class.define_method("details", method!(RpcFailure::details, 0))?;
    Ok(())
}

type CoreClient = RetryClient<ConfiguredClient<TemporalServiceClientWithMetrics>>;

#[derive(DataTypeFunctions, TypedData)]
#[magnus(class = "Temporalio::Bridge::Client", free_immediately)]
pub struct Client {
    pub(crate) core: CoreClient,
    runtime_handle: RuntimeHandle,
}

macro_rules! rpc_call {
    ($client:ident, $block:ident, $call:ident, $call_name:ident) => {{
        if $call.retry {
            let mut core_client = $client.core.clone();
            let req = $call.into_request()?;
            rpc_resp(
                $client,
                $block,
                async move { core_client.$call_name(req).await },
            )
        } else {
            let mut core_client = $client.core.clone().into_inner();
            let req = $call.into_request()?;
            rpc_resp(
                $client,
                $block,
                async move { core_client.$call_name(req).await },
            )
        }
    }};
}

impl Client {
    pub fn new(args: &[Value]) -> Result<(), Error> {
        let args = scan_args::scan_args::<(Obj<Runtime>,), (), (), (), _, Proc>(args)?;

        // TODO(cretz): Many more args
        let (target_host,) =
            scan_args::get_kwargs::<_, (String,), (), ()>(args.keywords, &["target_host"], &[])?
                .required;

        let mut opts_build = ClientOptionsBuilder::default();
        // TODO(cretz): HTTPS for TLS
        opts_build
            .target_url(
                Url::parse(format!("http://{}", target_host).as_str())
                    .map_err(|err| error!("Failed initializing telemetry: {}", err))?,
            )
            .client_name("temporal-ruby")
            .client_version("v0.1.0")
            .identity("unknown".to_owned());
        let opts = opts_build
            .build()
            .map_err(|err| error!("Invalid client config: {}", err))?;

        let runtime = args.required.0;
        let block = Opaque::from(args.block);
        let core_runtime = runtime.handle.core.clone();
        let runtime_handle = runtime.handle.clone();
        runtime.handle.spawn(
            async move {
                let core = opts
                    .connect_no_namespace(core_runtime.telemetry().get_temporal_metric_meter())
                    .await?;
                Ok(core)
            },
            move |ruby, result: Result<CoreClient, ClientInitError>| {
                let block = ruby.get_inner(block);
                match result {
                    Ok(core) => {
                        let _: Value = block
                            .call((Client {
                                core,
                                runtime_handle,
                            },))
                            .expect("Block call failed");
                    }
                    Err(err) => {
                        let _: Value = block
                            .call((new_error!("Failed client connect: {}", err),))
                            .expect("Block call failed");
                    }
                };
            },
        );
        Ok(())
    }

    pub fn call_workflow_service(&self, args: &[Value]) -> Result<(), Error> {
        let args = scan_args::scan_args::<(), (), (), (), _, Proc>(args)?;
        let (rpc, req, retry, metadata, timeout_millis) = scan_args::get_kwargs::<
            _,
            (String, RString, bool, Option<HashMap<String, String>>, u64),
            (),
            (),
        >(
            args.keywords,
            &["rpc", "req", "retry", "metadata", "timeout_millis"],
            &[],
        )?
        .required;
        let call = RpcCall {
            rpc,
            req: unsafe { req.as_slice() },
            retry,
            metadata,
            timeout_millis,
        };
        let block = Opaque::from(args.block);
        match call.rpc.as_str() {
            "start_workflow_execution" => {
                rpc_call!(self, block, call, start_workflow_execution)
            }
            _ => Err(error!("Unknown RPC call {}", call.rpc)),
        }
    }
}

#[derive(DataTypeFunctions, TypedData)]
#[magnus(class = "Temporalio::Bridge::Client::RpcFailure", free_immediately)]
pub struct RpcFailure {
    status: Status,
}

impl RpcFailure {
    pub fn code(&self) -> u32 {
        self.status.code() as u32
    }

    pub fn message(&self) -> &str {
        self.status.message()
    }

    pub fn details(&self) -> Option<RString> {
        if self.status.details().len() == 0 {
            None
        } else {
            Some(RString::from_slice(self.status.details()))
        }
    }
}

struct RpcCall<'a> {
    rpc: String,
    req: &'a [u8],
    retry: bool,
    metadata: Option<HashMap<String, String>>,
    timeout_millis: u64,
}

impl RpcCall<'_> {
    fn into_request<P: prost::Message + Default>(self) -> Result<tonic::Request<P>, Error> {
        let proto = P::decode(self.req).map_err(|err| error!("Invalid proto: {}", err))?;
        let mut req = tonic::Request::new(proto);
        if let Some(metadata) = self.metadata {
            for (k, v) in metadata {
                req.metadata_mut().insert(
                    MetadataKey::from_str(k.as_str())
                        .map_err(|err| error!("Invalid metadata key: {}", err))?,
                    v.parse()
                        .map_err(|err| error!("Invalid metadata value: {}", err))?,
                );
            }
        }
        if self.timeout_millis > 0 {
            req.set_timeout(Duration::from_millis(self.timeout_millis));
        }
        Ok(req)
    }
}

fn rpc_resp<P>(
    client: &Client,
    block: Opaque<Proc>,
    fut: impl Future<Output = Result<tonic::Response<P>, tonic::Status>> + Send + 'static,
) -> Result<(), Error>
where
    P: prost::Message,
    P: Default,
{
    client.runtime_handle.spawn(
        async move { fut.await.map(|msg| msg.get_ref().encode_to_vec()) },
        move |ruby, result| {
            let block = ruby.get_inner(block);
            match result {
                Ok(val) => {
                    // TODO(cretz): Any reasonable way to prevent byte copy?
                    let _: Value = block
                        .call((RString::from_slice(&val),))
                        .expect("Block call failed");
                }
                Err(status) => {
                    let _: Value = block
                        .call((RpcFailure { status },))
                        .expect("Block call failed");
                }
            };
        },
    );
    Ok(())
}
