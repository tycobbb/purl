final class CleanUrl: Service.Single {
  typealias Observer = (Bool) -> Void

  // -- deps --
  private let purl: Purl

  // -- props --
  let isLoading = State(false)

  // -- lifetime --
  init(purl: Purl = Purl()) {
    self.purl = purl
  }

  // -- command --
  func call(_ url: String) -> Void {
    self.isLoading.value = true
    purl.cleanUrl(url) { cleaned in
      self.isLoading.value = false
    }
  }

  // -- Service --
  static func make() -> Self {
    return self.init()
  }
}