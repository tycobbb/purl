use std::fs::File;
use std::io::{self, Read};
use toml;

// -- types --
#[derive(Deserialize, Debug)]
pub struct Rules {
    rules: Vec<Rule>,
}

#[derive(Deserialize, Debug)]
pub struct Rule {
    host: String,
    params: Vec<String>,
}

#[derive(Error, Debug)]
pub enum Error {
    #[error(transparent)]
    CouldNotReadFile(#[from] io::Error),
    #[error(transparent)]
    CouldNotDecodeFile(#[from] toml::de::Error),
}

// -- impls --
impl Rules {
    fn load() -> Result<Vec<Rule>, Error> {
        let mut file = File::open("rules.toml")?;
        let mut data = String::new();
        file.read_to_string(&mut data)?;
        let rules: Rules = toml::from_str(&data)?;
        return Ok(rules.rules);
    }
}

// -- tests --
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn it_loads_rules() {
        let rules = Rules::load();
        assert_eq!(rules.unwrap().len(), 1);
    }
}
