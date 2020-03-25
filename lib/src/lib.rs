// -- crates --
extern crate hyper;
extern crate hyper_tls;
extern crate libc;
extern crate tokio;

// -- modules --
#[macro_use]
mod syntax;
mod http;
mod purl;
mod url;

// -- imports --
use purl::Purl;
use url::Url;

// -- api --
#[no_mangle]
pub extern "C" fn purl_create() -> *mut Purl {
    let purl = Purl::new();
    let purl_box = Box::new(purl);

    return Box::into_raw(purl_box);
}

#[no_mangle]
pub extern "C" fn purl_destroy(purl: *mut Purl) {
    if purl.is_null() {
        return;
    }

    unsafe {
        let boxed = Box::from_raw(purl);
        drop(boxed);
    };
}

struct Context(*const std::ffi::c_void);

unsafe impl std::marker::Send for Context {}
unsafe impl std::marker::Sync for Context {}

#[no_mangle]
pub extern "C" fn purl_clean_url(
    purl_cptr: *mut Purl,
    url_ctpr: *const libc::c_char,
    callback: fn(*const std::ffi::c_void, *const libc::c_char) -> (),
    ctx_cptr: *const std::ffi::c_void,
) {
    let purl = unsafe {
        assert!(!purl_cptr.is_null());
        &mut *purl_cptr
    };

    let initial_cstr = unsafe {
        assert!(!url_ctpr.is_null());
        std::ffi::CStr::from_ptr(url_ctpr)
    };

    let initial: String = guard!(initial_cstr.to_str().map(|s| s.into()), else |err| {
        println!("could not decode cstr: {0}", err);
        callback(ctx_cptr, std::ptr::null());
        return
    });

    let ctx = Context(ctx_cptr);
    purl.runtime().spawn(async move {
        let mut url = Url::new(&initial);
        url.clean(&http::client()).await;

        let cleaned = guard!(url.cleaned(), else {
            println!("could not clean url: {0}", initial);
            callback(ctx.0, std::ptr::null());
            return
        });

        let cleaned_cstr = guard!(std::ffi::CString::new(cleaned), else |err| {
            println!("could not encode cstr: {0}", err);
            callback(ctx.0, std::ptr::null());
            return
        });

        callback(ctx.0, cleaned_cstr.into_raw());
    });
}

#[no_mangle]
pub extern "C" fn purl_destroy_url(url_cptr: *mut libc::c_char) {
    if url_cptr.is_null() {
        return;
    }

    unsafe {
        std::ffi::CString::from_raw(url_cptr);
    };
}

// -- tests --
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn it_cleans_a_url_async() {
        let purl = purl_create();
        let url = "https://httpbin.org/get\0";
        purl_clean_url(purl, url.as_ptr() as *const i8, |_, _| {}, std::ptr::null());
    }
}
