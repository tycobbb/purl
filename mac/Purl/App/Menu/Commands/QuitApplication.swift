import Cocoa

final class QuitApplication: Command {
  private let app: NSApplication

  // -- lifetime --
  init(app: NSApplication = .shared) {
    self.app = app
  }

  // -- command --
  func call() {
    app.terminate(nil)
  }

  // -- factories --
  static func item() -> MenuItem {
    return MenuItem(
      title: "Quit",
      command: QuitApplication()
    )
  }
}
