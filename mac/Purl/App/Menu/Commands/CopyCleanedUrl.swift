import Cocoa

final class CopyCleanedUrl: MenuCommand {
  // -- deps --
  private let cleanUrl: CleanUrl

  // -- lifetime --
  init(cleanUrl: CleanUrl = .get()) {
    self.cleanUrl = cleanUrl
  }

  // -- MenuCommand --
  func call() {
    if let url = NSPasteboard.general.string(forType: .string) {
      cleanUrl.call(url)
    }
  }

  // -- factories --
  static func item() -> MenuItem {
    return MenuItem(title: "Copy & Clean URL", command: CopyCleanedUrl())
  }
}
