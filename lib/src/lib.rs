// -- crates --
extern crate hyper;
extern crate hyper_tls;
extern crate libc;
extern crate tokio;

// -- modules --
#[macro_use]
mod syntax;
mod http;
mod url;

// -- imports --
use url::Url;

// -- api --
#[no_mangle]
pub extern "C" fn purl_clean_url(
    cptr_url: *const libc::c_char,
    callback: fn(*const std::ffi::c_void, *const libc::c_char) -> (),
    cptr_ctx: *const std::ffi::c_void,
) {
    let cstr_initial = unsafe {
        assert!(!cptr_url.is_null());
        std::ffi::CStr::from_ptr(cptr_url)
    };

    let initial = guard!(cstr_initial.to_str(), else |err| {
        println!("could not decode cstr: {0}", err);
        callback(cptr_ctx, std::ptr::null());
        return
    });

    let mut url = Url::new(initial);
    http::runtime().block_on(url.clean());

    let cleaned = guard!(url.cleaned(), else {
        println!("could not clean url");
        callback(cptr_ctx, std::ptr::null());
        return
    });

    let cstr_cleaned = guard!(std::ffi::CString::new(cleaned), else |err| {
        println!("could not encode cstr: {0}", err);
        callback(cptr_ctx, std::ptr::null());
        return
    });

    callback(cptr_ctx, cstr_cleaned.into_raw());
}

#[no_mangle]
pub extern "C" fn purl_free_url(cptr: *mut libc::c_char) {
    unsafe {
        if cptr.is_null() {
            return;
        }

        std::ffi::CString::from_raw(cptr);
    };
}
