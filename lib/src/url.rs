use crate::http;

// -- types --
pub struct Url {
    pub initial: http::Uri,
    pub cleaned: Result<http::Uri, Error>,
}

#[derive(Error, Debug)]
pub enum Error {
    #[error("This URL has not been cleaned.")]
    NotCleaned,
    #[error(transparent)]
    CouldNotRequestUrl(#[from] http::client::Error),
    #[error(transparent)]
    CouldNotGetRedirect(#[from] http::response::Error),
    #[error(transparent)]
    CouldNotParseUrl(#[from] http::uri::Error),
}

// -- impls --
impl Url {
    // -- lifetime --
    pub fn new(initial: &str) -> Result<Self, http::uri::Error> {
        let uri = http::uri(initial.trim())?;
        let url = Url {
            initial: uri,
            cleaned: Err(Error::NotCleaned),
        };

        return Ok(url);
    }

    // -- commands --
    pub async fn clean(&mut self, client: &http::Client) {
        self.cleaned = self.follow(&self.initial, client).await;
    }

    // -- commands/helpers
    async fn follow(&self, uri: &http::Uri, client: &http::Client) -> Result<http::Uri, Error> {
        let res = client.head(uri).await?;
        let uri = match res.status() {
            200..=299 => uri.clone(),
            300..=399 => {
                let loc = res.location()?;
                http::uri(loc)?
            }
            _ => Err(Error::NotCleaned)?,
        };

        return Ok(uri);
    }
}

// -- tests --
#[cfg(test)]
mod tests {
    use super::Url;
    use crate::http;
    use crate::purl::Purl;

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

    #[test]
    fn cleans_a_url() {
        let mut url = Url::new("https://httpbin.org/get").unwrap();
        let mut purl = Purl::new();
        let client = http::client();

        let task = url.clean(&client);
        purl.runtime().block_on(task);

        assert_eq!(url.cleaned.unwrap(), "https://httpbin.org/get");
    }

    #[test]
    fn follows_redirects() {
        let mut url =
            Url::new("https://httpbin.org/redirect-to?url=https%3A%2F%2Fhttpbin.org%2Fget")
                .unwrap();

        let mut purl = Purl::new();
        let http = http::client();

        let task = url.clean(&http);
        purl.runtime().block_on(task);

        assert_eq!(url.cleaned.unwrap(), "https://httpbin.org/get");
    }
}
