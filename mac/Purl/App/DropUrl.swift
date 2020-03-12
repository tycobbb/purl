import Cocoa

final class DropUrl: NSObject, NSWindowDelegate, NSDraggingDestination {
  // -- NSDragginDestination --
  func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
    return .generic
  }

  func draggingEnded(_ sender: NSDraggingInfo) {
    let pasteboard = sender.draggingPasteboard

    guard let text = pasteboard.string(forType: .string) else {
      let types = pasteboard.pasteboardItems?.flatMap { $0.types }
      print("drag failed, types: \(types ?? [])")
      return
    }

    purl_clean_url(text)
  }
}
