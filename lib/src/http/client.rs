use super::{Response, Uri};
use hyper;
use hyper_tls;

// -- types --
pub struct Client(
    hyper::Client<hyper_tls::HttpsConnector<hyper::client::HttpConnector>, hyper::Body>,
);

#[derive(Error, Debug)]
pub enum Error {
    #[error(transparent)]
    FailedToBuildRequest(#[from] hyper::http::Error),
    #[error(transparent)]
    RequestFailed(#[from] hyper::Error),
}

// -- impls --
pub fn client() -> Client {
    return Client(hyper::Client::builder().build(hyper_tls::HttpsConnector::new()));
}

impl Client {
    pub async fn head(&self, uri: &Uri) -> Result<Response, Error> {
        let req = hyper::Request::head(uri).body(hyper::Body::empty())?;
        let res = self.0.request(req).await?;
        return Ok(Response::from(res));
    }
}
