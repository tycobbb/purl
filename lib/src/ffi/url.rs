use crate::queue::Queue;
use crate::url::Url;
use std::convert::TryInto;

// -- impls --
// #[no_mangle]
// pub extern "C" fn purl_url_initial(ptr: *const Url) -> u32 {
//     let _ = unsafe {
//         assert!(!ptr.is_null());
//         &*ptr
//     };

//     // TODO: how to handle this error?
//     return null
// }

// #[no_mangle]
// pub extern "C" fn purl_url_cleaned_ok(ptr: *const Url) -> bool {
//     let _ = unsafe {
//         assert!(!ptr.is_null());
//         &*ptr
//     };

//     return null;
// }

// #[no_mangle]
// pub extern "C" fn purl_url_cleaned_err(ptr: *const Url) -> bool {
//     let _ = unsafe {
//         assert!(!ptr.is_null());
//         &*ptr
//     };

//     return false;
// }
