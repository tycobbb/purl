pub fn parse_param(uri: &str) -> Result<(&str, String), &str> {
    let mut chars = uri.chars();

    // check for a leading '?' or '&'
    match chars.next() {
        Some(next) if next == '?' || next == '&' => (),
        _ => return Err(uri),
    };

    // collect until the next '&' or end-of-string
    let mut param = String::new();

    while let Some(next) = chars.next() {
        if next.is_alphanumeric() || next == '=' || next == '&' {
            param.push(next);
        }

        if next == '&' {
            break;
        }
    }

    return Ok((&uri[param.len() + 1..], param));
}

// -- tests --
#[cfg(test)]
mod tests {
    pub use super::*;

    #[test]
    fn it_parses_a_param() {
        let query = "?k1=test1&k2=test2";

        let first = parse_param(query);
        assert_eq!(first, Ok(("k2=test2", "k1=test1&".to_string())));

        let second = parse_param(first.unwrap().0);
        assert_eq!(second, Ok(("", "k2=test2".to_string())));
    }
}
