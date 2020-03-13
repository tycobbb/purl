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
pub extern "C" fn purl_clean_url(cptr: *const libc::c_char) {
    let cstr = unsafe {
        assert!(!cptr.is_null());
        std::ffi::CStr::from_ptr(cptr)
    };

    let raw = guard!(cstr.to_str(), else |error| {
        return println!("could not get url string: {0}", error)
    });

    let mut url = Url::new(raw);
    http::runtime().block_on(url.clean());
}
