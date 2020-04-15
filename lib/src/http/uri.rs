use hyper;

// -- types --
pub type Uri = hyper::Uri;

#[derive(Error, Debug)]
pub enum Error {
    #[error(transparent)]
    IsInvalid(#[from] hyper::http::uri::InvalidUri),
    #[error("URI is not absolute.")]
    IsNotAbsolute,
}

// -- impls --
pub fn uri(url: &str) -> Result<Uri, Error> {
    let uri = url.parse::<Uri>()?;
    if uri.scheme_str().is_none() || uri.host().is_none() {
        return Err(Error::IsNotAbsolute);
    }

    return Ok(uri);
}

// -- tests --
#[cfg(test)]
mod tests {
    use super::{uri, Error};

    #[test]
    fn create_a_valid_uri() {
        let url = uri("https://httpbin.org/get");
        assert!(url.is_ok());
    }

    #[test]
    fn cant_create_an_relative_uri() {
        let url = uri("this is not a url");
        assert!(url.is_err());
        assert_ne!(url, Err(Error::IsNotAbsolute));
    }

    #[test]
    fn cant_create_an_invalid_uri() {
        let url = uri("website");
        assert_eq!(url, Err(Error::IsNotAbsolute));
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
