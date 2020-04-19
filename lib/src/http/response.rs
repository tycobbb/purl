use hyper as h;
use hyper::http::header as h_header;

// -- types --
pub struct Response(h::Response<h::Body>);

#[derive(Error, Debug)]
pub enum Error {
    #[error("Request had no `Location` header.")]
    MissingLocation,
    #[error(transparent)]
    CouldNotParseLocation(#[from] h_header::ToStrError),
}

// -- impls --
impl From<h::Response<h::Body>> for Response {
    fn from(res: h::Response<h::Body>) -> Response {
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

    fn header(&self, key: &str) -> Option<&hyper::http::HeaderValue> {
        return self.0.headers().get(key);
    }
}
