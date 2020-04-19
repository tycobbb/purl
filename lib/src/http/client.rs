use super::{Response, Uri};
use hyper as h;
use hyper_tls as h_tls;

// -- types --
pub struct Client(h::Client<h_tls::HttpsConnector<h::client::HttpConnector>, h::Body>);

#[derive(Error, Debug)]
pub enum Error {
    #[error(transparent)]
    CouldNotBuildRequest(#[from] h::http::Error),
    #[error(transparent)]
    CouldNotMakeRequest(#[from] h::Error),
}

// -- impls --
pub fn client() -> Client {
    return Client(h::Client::builder().build(h_tls::HttpsConnector::new()));
}

impl Client {
    pub async fn head(&self, uri: &Uri) -> Result<Response, Error> {
        let req = h::Request::head(uri.parsed()).body(h::Body::empty())?;
        let res = self.0.request(req).await?;
        return Ok(Response::from(res));
    }
}
