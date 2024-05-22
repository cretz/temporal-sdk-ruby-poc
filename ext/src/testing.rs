use magnus::{
    block::Proc, class, function, method, prelude::*, scan_args, typed_data::Obj, value::Opaque,
    DataTypeFunctions, Error, Ruby, TypedData, Value,
};
use parking_lot::Mutex;
use temporal_sdk_core::ephemeral_server;

use crate::{
    error, new_error,
    runtime::{Runtime, RuntimeHandle},
    ROOT_MOD,
};

pub fn init(ruby: &Ruby) -> Result<(), Error> {
    let root_mod = ruby.get_inner(&ROOT_MOD);

    let module = root_mod.define_module("Testing")?;

    let class = module.define_class("EphemeralServer", class::object())?;
    class.define_singleton_method(
        "start_dev_server",
        function!(EphemeralServer::start_dev_server, -1),
    )?;
    class.define_method("target", method!(EphemeralServer::target, 0))?;
    class.define_method("shutdown", method!(EphemeralServer::shutdown, -1))?;
    Ok(())
}

#[derive(DataTypeFunctions, TypedData)]
#[magnus(
    class = "Temporalio::Bridge::Testing::EphemeralServer",
    free_immediately
)]
pub struct EphemeralServer {
    core: Mutex<Option<ephemeral_server::EphemeralServer>>,
    target: String,
    runtime_handle: RuntimeHandle,
}

impl EphemeralServer {
    pub fn start_dev_server(args: &[Value]) -> Result<(), Error> {
        let args = scan_args::scan_args::<(Obj<Runtime>,), (), (), (), (), Proc>(args)?;

        let conf = ephemeral_server::TemporalDevServerConfigBuilder::default()
            .exe(ephemeral_server::EphemeralExe::CachedDownload {
                version: ephemeral_server::EphemeralExeVersion::SDKDefault {
                    sdk_name: "sdk-ruby".to_owned(),
                    sdk_version: "0.1.0".to_owned(),
                },
                dest_dir: None,
            })
            .build()
            .map_err(|err| error!("Invalid dev server config: {}", err))?;

        let runtime = args.required.0;
        let block = Opaque::from(args.block);
        let runtime_handle = runtime.handle.clone();
        runtime.handle.spawn(
            async move { conf.start_server().await },
            move |ruby, result| {
                let block = ruby.get_inner(block);
                match result {
                    Ok(core) => {
                        let _: Value = block
                            .call((EphemeralServer {
                                target: core.target.clone(),
                                core: Mutex::new(Some(core)),
                                runtime_handle,
                            },))
                            .expect("Block call failed");
                    }
                    Err(err) => {
                        let _: Value = block
                            .call((new_error!("Failed starting server: {}", err),))
                            .expect("Block call failed");
                    }
                }
            },
        );
        Ok(())
    }

    pub fn target(&self) -> &str {
        &self.target
    }

    pub fn shutdown(&self, args: &[Value]) -> Result<(), Error> {
        let args = scan_args::scan_args::<(), (), (), (), (), Proc>(args)?;
        if let Some(mut core) = self.core.lock().take() {
            let block = Opaque::from(args.block);
            self.runtime_handle
                .spawn(async move { core.shutdown().await }, move |ruby, result| {
                    let block = ruby.get_inner(block);
                    match result {
                        Ok(_) => {
                            let _: Value = block.call((ruby.qnil(),)).expect("Block call failed");
                        }
                        Err(err) => {
                            let _: Value = block
                                .call((new_error!("Failed shutting down server: {}", err),))
                                .expect("Block call failed");
                        }
                    };
                })
        }
        Ok(())
    }
}
