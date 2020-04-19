use crate::http;
use crate::queue::Queue;
use crate::url::{self, Url};
use tokio;

// -- types --
pub struct Purl {
    queue: Queue,
    runtime: tokio::runtime::Runtime,
}

// -- impls --
impl Purl {
    pub fn new() -> Purl {
        use tokio::runtime;

        return Purl {
            queue: Queue::new(),
            runtime: runtime::Runtime::new().unwrap(),
        };
    }

    // -- impls/commands
    pub fn add_url(
        &'static mut self,
        initial: &'static str,
        callback: impl FnOnce(usize) + Send + 'static,
    ) -> Result<(), http::uri::Error> {
        let url = Url::new(initial)?;
        let uri = url.initial.clone();

        let urls = &self.queue;
        let url_id = urls.add(url);

        self.runtime.spawn(async move {
            let cleaned = url::clean(&uri).await;
            urls.clean(url_id, cleaned);
            callback(url_id);
        });

        return Ok(());
    }

    // -- impls/queries
    pub fn queue(&self) -> &Queue {
        return &self.queue;
    }
}

// -- tests --
#[cfg(test)]
mod tests {
    use super::*;
    use std::sync::{Arc, RwLock};

    static mut PURL: Option<Purl> = None;

    #[test]
    #[ignore]
    fn adds_a_url_async() {
        let _ = unsafe {
            PURL = Some(Purl::new());
        };

        let initial = "https://httpbin.org/get";

        let id = Arc::new(RwLock::new(Option::<usize>::None));
        let added = {
            let p = unsafe { PURL.as_mut().unwrap() };
            let i = id.clone();
            p.add_url(initial, move |url_id| {
                *i.write().unwrap() = Some(url_id);
            })
        };

        assert!(added.is_ok());

        let mut i = 0;
        while id.read().unwrap().is_none() && i < 500 {
            std::thread::sleep(std::time::Duration::from_millis(10));
            i += 1;
        }

        assert_eq!(id.read().unwrap().unwrap(), 0);
    }
}
