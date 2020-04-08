import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate, NSDraggingDestination {
  var window: NSWindow!

  // -- NSApplicationDelegate --
  func applicationDidFinishLaunching(_: Notification) {
    MainView.insert()
  }
}
