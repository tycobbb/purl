import Cocoa

final class CleanCopiedUrl: Command {
  // -- deps --
  private let purl: Purl

  // -- lifetime --
  init(purl: Purl = .get()) {
    self.purl = purl
  }

  // -- command --
  func call() {
    if let url = NSPasteboard.general.string(forType: .string) {
      self.purl.addUrl(url)
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
