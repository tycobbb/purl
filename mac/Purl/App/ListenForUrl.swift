import Cocoa

final class ListenForUrl: Service.Single {
  // -- deps --
  private let pasteboard: NSPasteboard
  private let cleanUrl: CleanUrl

  // -- props --
  private var signal: Signal<()>?

  // -- lifetime --
  init(pasteboard: NSPasteboard = .general, cleanUrl: CleanUrl = CleanUrl.get()) {
    self.pasteboard = pasteboard
    self.cleanUrl = cleanUrl
  }

  // -- command --
  func start() {
    var current: String?

    signal = every(seconds: 0.5).on { [weak self] _ in
      guard let url = self?.pasteboard.string(forType: .URL), current != url else {
        return
      }

      current = url
      self?.cleanUrl.call(url)
    }
  }

  // -- Service --
  static func make() -> ListenForUrl {
    return ListenForUrl()
  }
}
