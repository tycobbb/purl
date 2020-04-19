import Cocoa

final class CleanCopiedUrl: Command {
  // -- deps --
  private let cleanUrl: AddUrl

  // -- lifetime --
  init(cleanUrl: AddUrl = .get()) {
    self.cleanUrl = cleanUrl
  }

  // -- command --
  func call() {
    if let url = NSPasteboard.general.string(forType: .string) {
      cleanUrl.call(url)
    }
  }

  // -- factories --
  static func item() -> MenuItem {
    return MenuItem(
      title: "Copy & Clean URL",
      key: "C",
      command: CleanCopiedUrl()
    )
  }
}
