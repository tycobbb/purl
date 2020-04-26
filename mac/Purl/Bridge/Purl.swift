import Foundation

final class Purl: Service.Single {
  // -- types --
  fileprivate typealias Callback = (UInt32) -> Void

  // -- deps --
  private let ptr: purl_t

  // -- props --
  let request: State<Request<Uri, Error>?> = State(nil)

  // -- lifetime --
  init(_ ptr: purl_t = purl_create()) {
    self.ptr = ptr
  }

  deinit {
    purl_destroy(ptr)
  }

  // -- commands --
  func addUrl(_ initial: String, queue: DispatchQueue = .main) {
    func inner(callback: @escaping Callback) {
      let raw = Box<Callback>.wrap(callback)

      if purl_add_url(ptr, initial, purl_callback, raw) {
        request.push(.loading)
      } else {
        _ = Box<Purl.Callback>.unwrap(raw)
      }
    }

    inner { id in
      queue.async {
        let cleaned = self.url(id).cleaned
        if purl_is_loading(self.ptr) {
          return
        }

        let result: Result<Uri, Error>
        if let cleaned = cleaned {
          result = cleaned.mapError(Error.url)
        } else {
          result = .failure(.unknown)
        }

        self.request.push(.complete(result))
      }
    }
  }

  // -- queries --
  var size: Url.Id {
    return purl_size(ptr)
  }

  func url(_ id: Url.Id) -> Url {
    return Url(purl_get_url(ptr, id))
  }

  // -- Service.Single --
  static func make() -> Purl {
    return Purl()
  }
}

// -- events --
private func purl_callback(id: UInt32, ctx: UnsafeMutableRawPointer!) {
  precondition(ctx != nil, "libpurl must pass context through callback")
  Box<Purl.Callback>.unwrap(ctx)(id)
}
