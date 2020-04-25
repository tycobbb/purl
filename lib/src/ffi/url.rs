use crate::url::Url;
use libc::c_char;
use std::sync::Arc;

// -- impls --
#[no_mangle]
pub extern "C" fn purl_url_drop(ptr: *const Arc<Url>) {
    unsafe {
        assert!(!ptr.is_null());
        Arc::from_raw(ptr);
    };
}

#[no_mangle]
pub extern "C" fn purl_url_initial(ptr: *const Arc<Url>) -> *const c_char {
    let url = unsafe {
        assert!(!ptr.is_null());
        &*ptr
    };

    return into_raw_cstr(url.initial.raw());
}

#[no_mangle]
pub extern "C" fn purl_url_cleaned_ok(ptr: *const Url) -> *const c_char {
    let url = unsafe {
        assert!(!ptr.is_null());
        &*ptr
    };

    return match &url.cleaned {
        Some(Ok(uri)) => into_raw_cstr(uri.raw()),
        _ => return std::ptr::null(),
    };
}

#[no_mangle]
pub extern "C" fn purl_url_cleaned_err(ptr: *const Url) -> *const c_char {
    let url = unsafe {
        assert!(!ptr.is_null());
        &*ptr
    };

    return match &url.cleaned {
        Some(Err(err)) => into_raw_cstr(&format!("{:?}", err)),
        _ => return std::ptr::null(),
    };
}

#[no_mangle]
pub extern "C" fn purl_uri_drop(ptr: *mut c_char) {
    from_raw_cstr(ptr);
}

#[no_mangle]
pub extern "C" fn purl_err_drop(ptr: *mut c_char) {
    from_raw_cstr(ptr);
}

// -- impls/helpers
use std::ffi::CString;

fn into_raw_cstr(string: &str) -> *const c_char {
    return match CString::new(string) {
        Ok(cstr) => cstr.into_raw(),
        Err(err) => std::ptr::null(),
    };
}

fn from_raw_cstr(ptr: *mut c_char) {
    unsafe {
        if !ptr.is_null() {
            CString::from_raw(ptr);
        }
    };
}
