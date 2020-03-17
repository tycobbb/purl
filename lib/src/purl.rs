use tokio;

// -- types --
pub struct Purl(tokio::runtime::Runtime);

// -- impls --
impl Purl {
    pub fn new() -> Purl {
        let runtime = guard!(tokio::runtime::Runtime::new(), else |error| {
            panic!("could not create runtime: {0}", error)
        });

        return Purl(runtime);
    }

    pub fn runtime(&mut self) -> &mut tokio::runtime::Runtime {
        return &mut self.0;
    }
}
