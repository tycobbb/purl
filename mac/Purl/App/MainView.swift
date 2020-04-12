import Cocoa

final class MainView: Service.Single {
  // -- props --
  private let item: NSStatusItem
  private let icon: Icon

  // -- lifetime --
  init(item: NSStatusItem, listen: ListenForUrl = ListenForUrl.get()) {
    guard let view = item.button else {
      fatalError("status item must have a button")
    }

    // assign deps/props
    self.item = item
    self.icon = Icon(frame: view.bounds)

    // configure view
    item.menu = Menu.make()
    view.addSubview(icon)

    // register for drag & drop events
    listen.start()
  }

  // -- queries --
  var view: NSView {
    return item.button!
  }

  // -- factories --
  static func insert() {
    _ = get()
  }

  static func make() -> MainView {
    return MainView(
      item: NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    )
  }
}
