import Cocoa

final class ListenForUrl: Service.Single {
  // -- deps --
  private let purl: Purl
  private let pasteboard: NSPasteboard

  // -- props --
  private var signal: Signal<()>?

  // -- lifetime --
  init(purl: Purl = .get(), pasteboard: NSPasteboard = .general) {
    self.purl = purl
    self.pasteboard = pasteboard
  }

  // -- command --
  func start() {
    var current: String?

    signal = every(seconds: 0.5).on { [weak self] _ in
      if let url = self?.pasteboard.string(forType: .string), current != url {
        current = url
        self?.purl.addUrl(url)
      }
    }
  }

  // -- Service --
  static func make() -> ListenForUrl {
    return ListenForUrl()
  }
}
