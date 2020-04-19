// -- crates --
extern crate hyper;
extern crate hyper_tls;
extern crate libc;
#[macro_use]
extern crate thiserror;
extern crate tokio;

// -- modules --
mod ffi;
mod http;
mod purl;
mod queue;
mod url;
