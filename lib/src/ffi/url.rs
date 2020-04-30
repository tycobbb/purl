use crate::url::Url;
use libc::c_char;
use std::sync::Arc;

// -- impls --
#[no_mangle]
pub extern "C" fn purl_url_drop(ptr: *const Url) {
    unsafe {
        assert!(!ptr.is_null());
        Arc::from_raw(ptr);
    };
}

#[no_mangle]
pub extern "C" fn purl_url_initial(ptr: *const Url) -> *const c_char {
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
        Some(Err(err)) => into_raw_cstr(&format!("{}", err)),
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
        Err(err) => {
            println!("error encoding c string: {:?}", err);
            std::ptr::null()
        }
    };
}

fn from_raw_cstr(ptr: *mut c_char) {
    unsafe {
        if !ptr.is_null() {
            CString::from_raw(ptr);
        }
    };
}

// -- tests --
#[cfg(test)]
mod tests {
    use super::*;
    use crate::http::Uri;
    use crate::url::clean;

    fn from_raw(ptr: *const c_char) -> CString {
        return unsafe { CString::from_raw(ptr as *mut c_char) };
    }

    #[test]
    fn gets_the_initial_uri_ptr() {
        let url = Url::new("https://test.com").unwrap();

        let ptr = purl_url_initial(&url);
        assert_eq!(from_raw(ptr).to_str().unwrap(), "https://test.com");
    }

    #[test]
    fn gets_the_cleaned_uri_ptr() {
        let url = Url::new("https://test.com")
            .unwrap()
            .clean(Uri::new("https://test.org").map_err(clean::Error::from));

        let ptr = purl_url_cleaned_ok(&url);
        assert_eq!(from_raw(ptr).to_str().unwrap(), "https://test.org");
    }

    #[test]
    fn gets_the_clean_err_ptr() {
        let url = Url::new("https://test.com")
            .unwrap()
            .clean(Err(clean::Error::RequestFailed(500)));

        let ptr = purl_url_cleaned_err(&url);
        assert_eq!(
            from_raw(ptr).to_str().unwrap(),
            "Request failed with status code: 500",
        );
    }
}
