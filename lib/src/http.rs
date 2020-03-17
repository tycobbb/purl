use hyper;
use hyper_tls;

// -- types --
pub type Client =
    hyper::Client<hyper_tls::HttpsConnector<hyper::client::HttpConnector>, hyper::Body>;

// -- impls --
pub fn client() -> Client {
    return hyper::Client::builder().build(hyper_tls::HttpsConnector::new());
}
