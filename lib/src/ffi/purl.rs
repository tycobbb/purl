use crate::purl::Purl;
use crate::url::Url;
use std::convert::TryInto;
use std::sync::Arc;

// -- types --
struct Context(*const std::ffi::c_void);

// -- impls --
#[no_mangle]
pub extern "C" fn purl_create() -> *mut Purl {
    return Box::into_raw(Box::new(Purl::new()));
}

#[no_mangle]
pub extern "C" fn purl_destroy(ptr: *mut Purl) {
    if ptr.is_null() {
        return;
    }

    unsafe {
        drop(Box::from_raw(ptr));
    };
}

#[no_mangle]
pub extern "C" fn purl_add_url(
    ptr: *mut Purl,
    initial_ptr: *const libc::c_char,
    callback: fn(u32, *const std::ffi::c_void) -> (),
    context_ptr: *const std::ffi::c_void,
) -> bool {
    let purl = unsafe {
        assert!(!ptr.is_null());
        &mut *ptr
    };

    let initial_cstr = unsafe {
        assert!(!initial_ptr.is_null());
        std::ffi::CStr::from_ptr(initial_ptr)
    };

    let initial = match initial_cstr.to_str() {
        Ok(initial) => initial,
        Err(_) => return false,
    };

    let context = Context(context_ptr);
    let added = purl.add_url(initial, move |url_id| {
        // TODO: how to handle this error?
        callback(url_id.try_into().unwrap(), context.0);
    });

    return added.is_ok();
}

#[no_mangle]
pub extern "C" fn purl_is_loading(ptr: *const Purl) -> bool {
    let purl = unsafe {
        assert!(!ptr.is_null());
        &*ptr
    };

    return purl.queue().loading();
}

#[no_mangle]
pub extern "C" fn purl_size(ptr: *const Purl) -> u32 {
    let purl = unsafe {
        assert!(!ptr.is_null());
        &*ptr
    };

    // TODO: how to handle this error?
    return purl.queue().len().try_into().unwrap();
}

#[no_mangle]
pub extern "C" fn purl_get_url(ptr: *const Purl, id: u32) -> *const Url {
    let purl = unsafe {
        assert!(!ptr.is_null());
        &*ptr
    };

    // TODO: how to handle this error?
    return Arc::into_raw(purl.queue().url(id.try_into().unwrap()));
}

// -- impls/context
unsafe impl std::marker::Send for Context {}
unsafe impl std::marker::Sync for Context {}
