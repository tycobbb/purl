import Foundation

final class Purl {
  // -- types --
  fileprivate typealias DidCleanUrl = (UnsafePointer<Int8>?) -> Void

  // -- commands --
  func cleanUrl(_ initial: String, callback: @escaping (String?) -> Void) {
    let callback: Ref<DidCleanUrl> = .init { (url: UnsafePointer<Int8>?) in
      var cleaned: String? = nil

      if let url = url {
        cleaned = String(cString: url)
        purl_free_url(url)
      }

      callback(cleaned)
    }

    purl_clean_url(initial, bridge_didCleanUrl(ctx:url:), callback.retained())
  }
}

// -- events --
private func bridge_didCleanUrl(ctx: UnsafeMutableRawPointer!, url: UnsafePointer<Int8>?) {
  precondition(ctx != nil, "libpurl must pass context through callback")

  let callback = Ref<Purl.DidCleanUrl>.fromRetained(ctx)
  callback.value(url)
}
