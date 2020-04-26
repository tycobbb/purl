extension Purl {
  struct Uri: Equatable {
    // -- props --
    let raw: String

    // -- lifetime --
    init(_ ptr: purl_uri_t) {
      let uri = String(cString: ptr)
      purl_uri_drop(ptr)
      raw = uri
    }
  }
}
