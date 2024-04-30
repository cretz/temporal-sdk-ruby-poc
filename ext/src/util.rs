use std::ffi::c_void;

/// Inspired by https://github.com/matsadler/magnus/pull/14 and
/// https://github.com/matsadler/magnus/pull/48 and
/// https://github.com/danielpclark/rutie/blob/master/src/binding/thread.rs and
/// others.
pub(crate) fn without_gvl<F, R, U>(func: F, unblock: U) -> R
where
    F: FnMut() -> R,
    U: FnMut(),
{
    unsafe extern "C" fn anon_func<F, R>(data: *mut c_void) -> *mut c_void
    where
        F: FnMut() -> R,
    {
        let mut func: F = *Box::from_raw(data as _);

        // TODO(cretz): Handle panics/unwind via call_handle_error?
        Box::into_raw(Box::new(func())) as _
    }

    unsafe extern "C" fn anon_unblock<U>(data: *mut c_void)
    where
        U: FnMut(),
    {
        let mut func: U = *Box::from_raw(data as _);

        func();
    }

    let boxed_func = Box::new(func);
    let boxed_unblock = Box::new(unblock);

    unsafe {
        let result = rb_sys::rb_thread_call_without_gvl(
            Some(anon_func::<F, R>),
            Box::into_raw(boxed_func) as *mut _,
            Some(anon_unblock::<U>),
            Box::into_raw(boxed_unblock) as *mut _,
        );

        *Box::from_raw(result as _)
    }
}
