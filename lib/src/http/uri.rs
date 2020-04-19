use hyper as h;
use hyper::http::uri as h_uri;

// -- types --
#[derive(Clone, Debug, PartialEq)]
pub struct Uri {
    raw: String,
    uri: h::http::Uri,
}

#[derive(Error, Debug)]
pub enum Error {
    #[error(transparent)]
    IsInvalid(#[from] h_uri::InvalidUri),
    #[error("URI is not absolute.")]
    IsNotAbsolute,
}

// -- impls --
impl Uri {
    // -- impls/lifetime
    pub fn new(string: &str) -> Result<Uri, Error> {
        let parsed = string.parse::<h::Uri>()?;

        if parsed.scheme_str().is_none() || parsed.host().is_none() {
            return Err(Error::IsNotAbsolute);
        }

        return Ok(Uri {
            raw: string.to_owned(),
            uri: parsed,
        });
    }

    // -- impls/queries
    // pub fn raw(&self) -> &str {
    //     return &self.raw;
    // }

    pub fn parsed(&self) -> &h::Uri {
        return &self.uri;
    }
}

// -- tests --
#[cfg(test)]
mod tests {
    use super::{Error, Uri};

    #[test]
    fn validates_a_uri() {
        let uri = Uri::new("https://httpbin.org/get");
        assert!(uri.is_ok());
    }

    #[test]
    fn invalidates_a_non_uri() {
        let uri = Uri::new("this is not a uri");
        assert!(uri.is_err());
        assert_ne!(uri, Err(Error::IsNotAbsolute));
    }

    #[test]
    fn invalidates_a_relative_uri() {
        let uri = Uri::new("website");
        assert_eq!(uri, Err(Error::IsNotAbsolute));
    }

    // a good-enough-impl of PartialEq for these tests
    impl PartialEq<Error> for Error {
        fn eq(&self, other: &Error) -> bool {
            match (self, other) {
                (Error::IsNotAbsolute, Error::IsNotAbsolute) => true,
                _ => false,
            }
        }
    }
}
