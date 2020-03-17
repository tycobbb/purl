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
  func cleanUrl(_ initial: String, callback: @escaping (String?) -> Void) {
    let callback: Ref<DidCleanUrl> = .init { (url: UnsafePointer<Int8>?) in
      var cleaned: String? = nil

      if let url = url {
        cleaned = String(cString: url)
        purl_destroy_url(url)
      }

      callback(cleaned)
    }

    purl_clean_url(
      purl,
      initial,
      purl_didCleanUrl(ctx:url:),
      callback.retained()
    )
  }
}

// -- events --
private func purl_didCleanUrl(ctx: UnsafeMutableRawPointer!, url: UnsafePointer<Int8>?) {
  precondition(ctx != nil, "libpurl must pass context through callback")

  let callback = Ref<Purl.DidCleanUrl>.fromRetained(ctx)
  callback.value(url)
}
