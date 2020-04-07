import Cocoa

final class MainView {
  // -- props --
  private let view: NSStatusItem
  private let icon: Icon

  // -- lifetime --
  init(view: NSStatusItem, dropUrl: DropUrl = .get()) {
    // assign deps/props
    self.view = view
    self.icon = Icon(frame: view.button?.bounds ?? .zero)

    // configure view
    view.menu = Menu.make()
    view.button?.addSubview(icon)

    // register for drag & drop events
    dropUrl.addToWindow(window: view.button?.window)
  }

  // -- factories --
  static func insert(intoStatusBar bar: NSStatusBar = .system) -> MainView {
    return MainView(
      view: bar.statusItem(withLength: NSStatusItem.squareLength)
    )
  }
}
