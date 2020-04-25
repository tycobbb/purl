use crate::http;
use crate::url::{clean, Url};
use std::sync::{Arc, RwLock};

// -- types --
#[derive(Debug)]
pub struct Queue {
    urls: Arc<RwLock<Vec<Arc<Url>>>>,
}

// -- impls --
impl Queue {
    // -- lifetime --
    pub fn new() -> Self {
        return Queue {
            urls: Arc::new(RwLock::new(Vec::new())),
        };
    }

    // -- commands --
    pub fn add(&self, url: Url) -> usize {
        let mut urls = self.urls.write().unwrap();
        urls.push(Arc::new(url));
        return urls.len() - 1;
    }

    pub fn clean(&self, id: usize, cleaned: Result<http::Uri, clean::Error>) {
        let mut urls = self.urls.write().unwrap();
        urls[id] = Arc::new(urls[id].clean(cleaned))
    }

    // -- queries --
    pub fn loading(&self) -> bool {
        let urls = self.urls.read().unwrap();
        return urls.iter().any(|u| u.cleaned.is_none());
    }

    pub fn url(&self, id: usize) -> Arc<Url> {
        let urls = self.urls.read().unwrap();
        return urls[id].clone();
    }

    pub fn len(&self) -> usize {
        let urls = self.urls.read().unwrap();
        return urls.len();
    }
}

// -- tests --
#[cfg(test)]
mod tests {
    use super::Queue;
    use crate::url::Url;

    #[test]
    fn adds_a_url() {
        let queue = Queue::new();
        let url = Url::new("https://test.com").unwrap();

        let id = queue.add(url);
        assert_eq!(id, 0);
        assert_eq!(queue.len(), 1);

        let url = queue.url(0);
        assert_eq!(url.initial.raw(), "https://test.com");
        assert!(url.cleaned.is_none());
    }
}
