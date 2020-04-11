import Cocoa

final class CleanUrl: Service.Single {
  // -- deps --
  private let purl: Purl

  // -- props --
  let request: State<Request<String>?> = State(nil)

  // -- lifetime --
  init(purl: Purl = Purl()) {
    self.purl = purl
  }

  // -- command --
  func call(_ url: String) -> Void {
    self.request.push(.loading)

    purl.cleanUrl(url) { result in
      self.request.push(.complete(result))

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
