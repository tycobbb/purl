use hyper;

// -- types --
pub struct Response(hyper::Response<hyper::Body>);

#[derive(Error, Debug)]
pub enum Error {
    #[error("Request had no `Location` header.")]
    MissingLocation,
    #[error(transparent)]
    CouldNotParseLocation(#[from] hyper::http::header::ToStrError),
}

// -- impls --
impl From<hyper::Response<hyper::Body>> for Response {
    fn from(res: hyper::Response<hyper::Body>) -> Response {
        return Response(res);
    }
}

impl Response {
    // -- impls/queries
    pub fn status(&self) -> u16 {
        return self.0.status().as_u16();
    }

    pub fn location(&self) -> Result<&str, Error> {
        let location = self
            .header("Location")
            .ok_or(Error::MissingLocation)?
            .to_str()?;

        return Ok(location);
    }

    // -- impls/queries/helpers
    fn header(&self, key: &str) -> Option<&hyper::http::HeaderValue> {
        return self.0.headers().get(key);
    }
}
