import Cocoa

class ShowPreferences: MenuCommand {
  // -- MenuCommand --
  func call() {
    print("show preferences...")
  }

  // -- factories --
  static func item() -> MenuItem {
    return MenuItem(title: "Preferences...", command: ShowPreferences())
  }
}
