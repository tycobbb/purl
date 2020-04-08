import Cocoa

final class ShowPreferences: Command {
  // -- command --
  func call() {
    print("show preferences...")
  }

  // -- factories --
  static func item() -> MenuItem {
    return MenuItem(
      title: "Preferences...",
      command: ShowPreferences()
    )
  }
}
