import Cocoa

enum Menu {
  static func make() -> NSMenu {
    let menu = NSMenu()

    menu.addItem(CleanCopiedUrl.item())
    menu.addItem(.separator())
    menu.addItem(ShowPreferences.item())
    menu.addItem(QuitApplication.item())

    return menu
  }
}
