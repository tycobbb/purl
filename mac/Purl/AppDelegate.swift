import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate, NSDraggingDestination {
  var window: NSWindow!

  // -- props --
  private var main: MainView!

  // -- NSApplicationDelegate --
  func applicationDidFinishLaunching(_: Notification) {
    main = MainView.insert()
  }
}
