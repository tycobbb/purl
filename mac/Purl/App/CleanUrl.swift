import Cocoa

final class CleanUrl: Service.Single {
  // -- deps --
  private let purl: Purl

  // -- props --
  let request: Signal<Request<String>?> = Signal(nil)

  // -- lifetime --
  init(purl: Purl = Purl()) {
    self.purl = purl
  }

  // -- command --
  func call(_ url: String) -> Void {
    self.request.value = .loading

    purl.cleanUrl(url) { result in
      self.request.value = .complete(result)

      if case .success(let cleaned) = result {
        ShowNotification().call(cleaned)
      }
    }
  }

  // -- Service --
  static func make() -> Self {
    return self.init()
  }
}
