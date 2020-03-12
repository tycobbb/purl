import Cocoa

final class MainStatusItem {
  // -- deps --
  private let dropUrl: DropUrl

  // -- props --
  let view: NSStatusItem

  // -- lifetime --
  init(view: NSStatusItem, dropUrl: DropUrl = DropUrl()) {
    // assign deps/props
    self.view = view
    self.dropUrl = dropUrl

    // configure view
    view.button?.title = "◎"
    view.button?.window?.registerForDraggedTypes([.URL, .string, .html])
    view.button?.window?.delegate = dropUrl
  }

  // -- factories --
  static func addItem(toStatusBar statusBar: NSStatusBar) -> MainStatusItem {
    return MainStatusItem(
      view: statusBar.statusItem(withLength: NSStatusItem.squareLength)
    )
  }
}
