import Foundation

final class Purl {
  // -- types --
  fileprivate typealias Callback = (UInt32) -> Void

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
  func addUrl(_ initial: String, queue: DispatchQueue = .main, callback: @escaping (Result<String, AnyError>) -> Void) {
    func inner(callback: @escaping Callback) {
      let raw = Box<Callback>.wrap(callback)
      if !purl_add_url(purl, initial, purl_callback, raw) {
        _ = Box<Purl.Callback>.unwrap(raw)
      }
    }

    inner { id in
      let result: Result<String, AnyError> = .success("http://test.com")
      queue.async {
        callback(result)
      }
    }
  }
}

// -- events --
private func purl_callback(id: UInt32, ctx: UnsafeMutableRawPointer!) {
  precondition(ctx != nil, "libpurl must pass context through callback")
  Box<Purl.Callback>.unwrap(ctx)(id)
}
