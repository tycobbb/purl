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
pub extern "C" fn purl_clean_url(cptr: *const libc::c_char) -> *const libc::c_char {
    let cstr_initial = unsafe {
        assert!(!cptr.is_null());
        std::ffi::CStr::from_ptr(cptr)
    };

    let initial = guard!(cstr_initial.to_str(), else |err| {
        println!("could not decode cstr: {0}", err);
        return std::ptr::null()
    });

    let mut url = Url::new(initial);
    http::runtime().block_on(url.clean());

    let cleaned = guard!(url.cleaned(), else {
        println!("could not clean url");
        return std::ptr::null()
    });

    let cstr_cleaned = guard!(std::ffi::CString::new(cleaned), else |err| {
        println!("could not encode cstr: {0}", err);
        return std::ptr::null()
    });

    return cstr_cleaned.into_raw();
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
