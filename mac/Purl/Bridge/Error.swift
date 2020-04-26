extension Purl {
  enum Error: Swift.Error {
    case url(Url.Error)
    case unknown
  }
}
