import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
  // -- props --
  var window: NSWindow!

  // -- NSApplicationDelegate --
  func applicationWillFinishLaunching(_: Notification) {
    print("helllooo")
  }
  
  func applicationDidFinishLaunching(_: Notification) {
    print("hello, swift")
    print("\(purl())")
  }

  func applicationWillTerminate(_: Notification) {
  }
}
