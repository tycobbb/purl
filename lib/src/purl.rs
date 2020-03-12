// -- crates --
extern crate libc;

// -- modules --
#[macro_use]
mod syntax;

// -- api --
#[no_mangle]
pub extern "C" fn purl_clean_url(cptr: *const libc::c_char) {
    let cstr = unsafe {
        assert!(!cptr.is_null());
        std::ffi::CStr::from_ptr(cptr)
    };

    let url = guard!(cstr.to_str(), else |error| {
        return println!("clean url, error: {0}", error)
    });

    println!("clean url: {0}", url);
}
