use crate::http;

// -- types --
pub struct Url<'a> {
    initial: &'a str,
    cleaned: Option<String>,
}

// -- impls --
impl<'a> Url<'a> {
    // -- lifetime --
    pub fn new(initial: &'a str) -> Self {
        return Url {
            initial: initial,
            cleaned: None,
        };
    }

    // -- commands --
    pub async fn clean(&mut self) {
        let req = guard!(hyper::Request::head(self.initial).body(hyper::Body::empty()), else |err| {
            return println!("could not build request: {0}", err)
        });

        println!("cleaning uri: {0}", req.uri());
        let res = guard!(http::client().request(req).await, else |err| {
            return println!("could not make request: {0}", err)
        });

        fn get_header(res: hyper::Response<hyper::Body>, name: &str) -> Option<String> {
            Some(res.headers().get(name)?.to_str().ok()?.to_string())
        }

        self.cleaned = match res.status().as_u16() {
            200..=299 => Some(self.initial.to_string()),
            300..=399 => get_header(res, "Location"),
            _ => None,
        };
    }

    // -- queries --
    pub fn cleaned(&self) -> Option<&str> {
        return self.cleaned.as_deref();
    }
}

// -- tests --
#[cfg(test)]
mod tests {
    use super::Url;
    use crate::http;

    #[test]
    fn it_cleans_a_url() {
        let mut url = Url::new("https://httpbin.org/get");
        http::runtime().block_on(url.clean());
        assert_eq!(url.cleaned.unwrap(), "https://httpbin.org/get");
    }

    #[test]
    fn it_follows_a_redirect() {
        let mut url =
            Url::new("https://httpbin.org/redirect-to?url=https%3A%2F%2Fhttpbin.org%2Fget");
        http::runtime().block_on(url.clean());
        assert_eq!(url.cleaned.unwrap(), "https://httpbin.org/get");
    }
}
