import Cocoa

final class DropUrl: NSObject, NSWindowDelegate, NSDraggingDestination {
  // -- deps --
  private let purl: Purl

  // -- lifetime --
  init(purl: Purl = Purl()) {
    self.purl = purl
  }

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

    guard let url = purl.cleanUrl(text) else {
      print("failed to clean url: \(text)")
      return
    }

    print("cleaned url: \(url)")
  }
}
