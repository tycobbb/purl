use super::clean;
use crate::http::uri::{self, Uri};
use std::sync::Arc;

// -- types --
#[derive(Debug)]
pub struct Url {
    pub initial: Arc<Uri>,
    pub cleaned: Option<Result<Arc<Uri>, Arc<Error>>>,
}

#[derive(Error, Debug)]
pub enum Error {
    #[error(transparent)]
    CouldNotClean(#[from] clean::Error),
}

// -- impls --
impl Url {
    // -- lifetime --
    pub fn new(initial: &str) -> Result<Self, uri::Error> {
        return Ok(Url {
            initial: Arc::new(Uri::new(initial.trim())?),
            cleaned: None,
        });
    }

    // -- operators --
    pub fn clean(&self, cleaned: Result<Uri, clean::Error>) -> Url {
        return Url {
            initial: self.initial.clone(),
            cleaned: Some(cleaned.map_err(Error::from).map(Arc::new).map_err(Arc::new)),
        };
    }
}

// -- tests --
#[cfg(test)]
mod tests {
    use super::Url;

    #[test]
    fn create_a_valid_url() {
        let url = Url::new("https://httpbin.org/get");
        assert!(url.is_ok());
    }

    #[test]
    fn cant_create_an_invalid_url() {
        let url = Url::new("   \n\twebsite\r \r");
        assert!(url.is_err());
    }
}
