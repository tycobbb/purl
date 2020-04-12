import Cocoa

final class ListenForUrl: Service.Single {
  // -- deps --
  let cleanUrl: CleanUrl

  // -- props --
  private let shortcut = Shortcut()

  // -- lifetime --
  init(cleanUrl: CleanUrl = CleanUrl.get()) {
    self.cleanUrl = cleanUrl
  }

  // -- command --
  func start() {
    shortcut.listen().on { _ in
      if let url = NSPasteboard.general.string(forType: .string) {
        print("copied \(url)")
      }
    }
  }

  // -- Service --
  static func make() -> ListenForUrl {
    return ListenForUrl()
  }
}
