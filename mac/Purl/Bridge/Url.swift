extension Purl {
  final class Url {
    typealias Id = UInt32

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
      return Uri(purl_url_initial(ptr))
    }

    var cleaned: Result<Uri, Url.Error>? {
      if let ptr = purl_url_cleaned_ok(ptr) {
        return .success(Uri(ptr))
      } else if let ptr = purl_url_cleaned_err(ptr) {
        return .failure(Url.Error(ptr))
      } else {
        return nil
      }
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
