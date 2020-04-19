use super::clean;
use crate::http;

// -- types --
#[derive(Debug)]
pub struct Url {
    pub initial: http::Uri,
    pub cleaned: Option<Result<http::Uri, Error>>,
}

#[derive(Error, Debug)]
pub enum Error {
    #[error(transparent)]
    CouldNotClean(#[from] clean::Error),
}

// -- impls --
impl Url {
    // -- lifetime --
    pub fn new(initial: &str) -> Result<Self, http::uri::Error> {
        return Ok(Url {
            initial: http::Uri::new(initial.trim())?,
            cleaned: None,
        });
    }

    // -- commands --
    pub fn clean(&mut self, cleaned: Result<http::Uri, clean::Error>) {
        self.cleaned = Some(cleaned.map_err(Error::from));
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
