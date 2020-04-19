use crate::queue::Queue;
use std::convert::TryInto;

// -- impls --
#[no_mangle]
pub extern "C" fn purl_queue_size(ptr: *const Queue) -> u32 {
    let queue = unsafe {
        assert!(!ptr.is_null());
        &*ptr
    };

    // TODO: how to handle this error?
    return queue.len().try_into().unwrap();
}

#[no_mangle]
pub extern "C" fn purl_queue_loading(ptr: *const Queue) -> bool {
    let _ = unsafe {
        assert!(!ptr.is_null());
        &*ptr
    };

    return false;
}

// #[no_mangle]
// pub extern "C" fn purl_queue_get_url(ptr: *const Queue, id: u32) -> *const Url {
//     let queue = unsafe {
//         assert!(!ptr.is_null());
//         &*ptr
//     };

//     return queue.get(id);
// }
