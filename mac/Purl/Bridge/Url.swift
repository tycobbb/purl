extension Purl {
  final class Url {
    typealias Id = Int

    // -- props --
    private let ptr: purl_url_t

    // -- lifetime --
    init(_ ptr: purl_url_t) {
      self.ptr = ptr
    }

    deinit {
      purl_url_drop(ptr)
    }

    // -- queries --
    var initial: Uri {
      return uri(from: purl_url_initial(ptr))
    }

    var cleaned: Result<Uri, Url.Error>? {
      if let ptr = purl_url_cleaned_ok(ptr) {
        return .success(uri(from: ptr))
      } else if let ptr = purl_url_cleaned_err(ptr) {
        return .failure(Url.Error(ptr))
      } else {
        return nil
      }
    }

    // -- queries/helpers
    private func uri(from ptr: purl_uri_t) -> Uri {
      let uri = String(cString: ptr)
      purl_uri_drop(ptr)
      return uri
    }
  }
}

extension Purl.Url {
  struct Error: Swift.Error {
    // -- props --
    let raw: String

    // -- lifetime --
    init(_ ptr: purl_err_t) {
      let uri = String(cString: ptr)
      purl_err_drop(ptr)
      raw = uri
    }
  }
}
