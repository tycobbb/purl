import Cocoa

struct ShowNotification {
  // -- props --
  private let root: NSView

  // -- lifetime --
  init(root: NSView = MainView.get().view) {
    self.root = root
  }

  // -- command --
  func call(_ url: String) {
    let view = NotificationView.instance(with: url)
    let popover = NSPopover()
    popover.contentViewController = view
    popover.show(relativeTo: root.bounds, of: root, preferredEdge: .maxY)
    delay(seconds: 5, execute: popover.close)
  }
}
