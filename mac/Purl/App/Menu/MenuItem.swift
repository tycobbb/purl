import Cocoa

final class MenuItem: NSMenuItem {
  // -- props --
  private var command: Command?

  // -- lifetime --
  convenience init(title: String, key: String = "", command: Command) {
    self.init(title:  title, action: #selector(MenuItem.didSelectItem), keyEquivalent: key)

    // target self to invoke command
    self.target = self
    self.command = command
  }

  // -- events --
  @objc private func didSelectItem() {
    command?.call()
  }
}
