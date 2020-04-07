import Cocoa

final class DropUrl: NSObject, Service.Single, NSWindowDelegate, NSDraggingDestination {
  // -- deps --
  private let cleanUrl: CleanUrl

  // -- lifetime --
  init(cleanUrl: CleanUrl = .get()) {
    self.cleanUrl = cleanUrl
  }

  // -- commands --
  func addToWindow(window: NSWindow?) {
    window?.registerForDraggedTypes([.URL, .string, .html])
    window?.delegate = self
  }

  // -- NSDraggingDestination --
  func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
    return .generic
  }

  func draggingEnded(_ sender: NSDraggingInfo) {
    let pasteboard = sender.draggingPasteboard

    guard let url = pasteboard.string(forType: .string) else {
      let types = pasteboard.pasteboardItems?.flatMap { $0.types }
      print("drag failed, types: \(types ?? [])")
      return
    }

    cleanUrl.call(url)
  }

  // -- Service --
  static func make() -> Self {
    return self.init()
  }
}
