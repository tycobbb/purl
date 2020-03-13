use hyper;
use hyper_tls;
use tokio;

// -- types --
type Client = hyper::Client<hyper_tls::HttpsConnector<hyper::client::HttpConnector>, hyper::Body>;

// -- impls --
pub fn client() -> Client {
    hyper::Client::builder().build(hyper_tls::HttpsConnector::new())
}

pub fn runtime() -> tokio::runtime::Runtime {
    guard!(tokio::runtime::Runtime::new(), else |error| {
        panic!("could not create runtime: {0}", error)
    })
}
