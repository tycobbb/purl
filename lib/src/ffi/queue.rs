use crate::queue::Queue;
use crate::url::Url;
use std::convert::TryInto;
use std::sync::Arc;

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
    let queue = unsafe {
        assert!(!ptr.is_null());
        &*ptr
    };

    return queue.loading();
}

#[no_mangle]
pub extern "C" fn purl_queue_url(ptr: *const Queue, id: u32) -> *const Url {
    let queue = unsafe {
        assert!(!ptr.is_null());
        &*ptr
    };

    // TODO: how to handle this error?
    return Arc::into_raw(queue.url(id.try_into().unwrap()));
}
