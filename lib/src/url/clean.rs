use crate::http;

#[derive(Error, Debug)]
pub enum Error {
    #[error("Request failed with status code: ${0}")]
    RequestFailed(u16),
    #[error(transparent)]
    CouldNotRequestUrl(#[from] http::client::Error),
    #[error(transparent)]
    CouldNotGetRedirect(#[from] http::response::Error),
    #[error(transparent)]
    CouldNotParseUrl(#[from] http::uri::Error),
}

// -- command --
pub async fn clean(uri: &http::Uri) -> Result<http::Uri, Error> {
    let client = http::client();
    return follow(uri, &client).await;
}

// -- commands/helpers
async fn follow(uri: &http::Uri, client: &http::Client) -> Result<http::Uri, Error> {
    let res = client.head(uri).await?;
    let uri: http::Uri = match res.status() {
        200..=299 => uri.clone(),
        300..=399 => http::Uri::new(res.location()?)?,
        _ => Err(Error::RequestFailed(res.status()))?,
    };

    return Ok(uri);
}
