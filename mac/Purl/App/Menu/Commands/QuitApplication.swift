import Cocoa

final class QuitApplication: MenuCommand {
  private let app: NSApplication

  // -- lifetime --
  init(app: NSApplication = .shared) {
    self.app = app
  }

  // -- MenuCommand --
  func call() {
    app.terminate(nil)
  }

  // -- factories --
  static func item() -> MenuItem {
    return MenuItem(title: "Quit", command: QuitApplication())
  }
}
