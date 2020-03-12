import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate, NSDraggingDestination {
  var window: NSWindow!

  // -- props --
  private var main: MainStatusItem!

  // -- NSApplicationDelegate --
  func applicationDidFinishLaunching(_: Notification) {
    main = MainStatusItem.addItem(toStatusBar: .system)
  }
}
