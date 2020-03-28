import Cocoa

// -- types --
protocol DropUrlDelegate: class {
  func didChangeRequestState(to isLoading: Bool)
}

// -- impls --
final class DropUrl: NSObject, NSWindowDelegate, NSDraggingDestination {
  // -- deps --
  private let purl: Purl

  // -- props --
  private weak var delegate: DropUrlDelegate?

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

    delegate?.didChangeRequestState(to: true)

    purl.cleanUrl(text) { [weak self] url in
      self?.delegate?.didChangeRequestState(to: true)
    }
  }
}
