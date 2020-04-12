import Foundation

final class Purl {
  // -- types --
  fileprivate typealias DidCleanUrl = (UnsafePointer<Int8>?) -> Void

  // -- deps --
  private let purl: purl_t

  // -- lifetime --
  init(purl: purl_t = purl_create()) {
    self.purl = purl
  }

  deinit {
    purl_destroy(purl)
  }

  // -- commands --
  func cleanUrl(_ initial: String, queue: DispatchQueue = .main, callback: @escaping (Result<String, AnyError>) -> Void) {
    purl_clean_url(purl, initial, purl_didCleanUrl(ctx:url:), Box<DidCleanUrl>.wrap({ url in
      let result: Result<String, AnyError>

      if let url = url {
        result = .success(String(cString: url))
        purl_destroy_url(url)
      } else {
        result = .failure(AnyError())
      }

      queue.async {
        callback(result)
      }
    }))
  }
}

// -- events --
private func purl_didCleanUrl(ctx: UnsafeMutableRawPointer!, url: UnsafePointer<Int8>?) {
  precondition(ctx != nil, "libpurl must pass context through callback")
  Box<Purl.DidCleanUrl>.unwrap(ctx)(url)
}
