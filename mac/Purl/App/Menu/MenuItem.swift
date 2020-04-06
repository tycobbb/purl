import Cocoa

final class MenuItem: NSMenuItem {
  // -- props --
  private var command: MenuCommand?

  // -- lifetime --
  convenience init(title: String, command: MenuCommand) {
    self.init(title:  title, action: #selector(MenuItem.didSelectItem), keyEquivalent: "")

    // target self to invoke command
    self.target = self
    self.command = command
  }

  // -- events --
  @objc private func didSelectItem() {
    command?.call()
  }
}
