use super::{error, ROOT_MOD};
use crate::util::without_gvl;
use magnus::{
    class, function, method, prelude::*, DataTypeFunctions, Error, Ruby, TypedData, Value,
};
use std::sync::mpsc::{channel, Receiver, Sender};
use std::{future::Future, sync::Arc};
use temporal_sdk_core::CoreRuntime;
use temporal_sdk_core_api::telemetry::TelemetryOptionsBuilder;

pub fn init(ruby: &Ruby) -> Result<(), Error> {
    let class = ruby
        .get_inner(&ROOT_MOD)
        .define_class("Runtime", class::object())?;
    class.define_singleton_method("new", function!(Runtime::new, -1))?;
    class.define_method("run_command_loop", method!(Runtime::run_command_loop, 0))?;
    Ok(())
}

#[derive(DataTypeFunctions, TypedData)]
#[magnus(class = "Temporalio::Bridge::Runtime", free_immediately)]
pub struct Runtime {
    /// Separate cloneable handle that can be reference in other Rust objects.
    pub(crate) handle: RuntimeHandle,
    async_command_rx: Receiver<AsyncCommand>,
}

#[derive(Clone)]
pub(crate) struct RuntimeHandle {
    pub(crate) core: Arc<CoreRuntime>,
    async_command_tx: Sender<AsyncCommand>,
}

type Callback = Box<dyn FnOnce() + Send + 'static>;

enum AsyncCommand {
    RunCallback(Callback),
    Shutdown,
}

impl Runtime {
    pub fn new(_args: &[Value]) -> Result<Self, Error> {
        // TODO(cretz): Options
        let telemetry_build = TelemetryOptionsBuilder::default();

        let core = Arc::new(
            CoreRuntime::new(
                telemetry_build
                    .build()
                    .map_err(|err| error!("Invalid telemetry config: {}", err))?,
                tokio::runtime::Builder::new_multi_thread(),
            )
            .map_err(|err| error!("Failed initializing telemetry: {}", err))?,
        );

        let (async_command_tx, async_command_rx): (Sender<AsyncCommand>, Receiver<AsyncCommand>) =
            channel();
        Ok(Self {
            handle: RuntimeHandle {
                core,
                async_command_tx,
            },
            async_command_rx,
        })
    }

    pub fn run_command_loop(&self) {
        loop {
            let cmd = without_gvl(
                || self.async_command_rx.recv(),
                || {
                    // Ignore fail since we don't properly catch panics in
                    // without_gvl right now
                    let _ = self.handle.async_command_tx.send(AsyncCommand::Shutdown);
                },
            );
            if let Ok(AsyncCommand::RunCallback(callback)) = cmd {
                // TODO(cretz): Can we trust that this call is cheap?
                // TODO(cretz): Catch and unwind here?
                callback();
            } else {
                // We break on all errors/shutdown
                break;
            }
        }
    }
}

impl RuntimeHandle {
    /// Spawn the given future in Tokio and then, upon complete, call the given
    /// function inside a Ruby thread. The callback inside the Ruby thread must
    /// be cheap because it is one shared Ruby thread for everything. Therefore
    /// it should be something like a queue push or a fiber scheduling.
    pub(crate) fn spawn<T, F>(
        &self,
        without_gvl: impl Future<Output = T> + Send + 'static,
        with_gvl: F,
    ) where
        F: FnOnce(Ruby, T) + Send + 'static,
        T: Send + 'static,
    {
        let async_command_tx = self.async_command_tx.clone();
        self.core.tokio_handle().spawn(async move {
            let val = without_gvl.await;
            // Ignore fail to send in rare case that the runtime/handle is
            // dropped before this Tokio future runs
            let _ = async_command_tx
                .clone()
                .send(AsyncCommand::RunCallback(Box::new(move || {
                    if let Ok(ruby) = Ruby::get() {
                        with_gvl(ruby, val);
                    }
                })));
        });
    }
}
