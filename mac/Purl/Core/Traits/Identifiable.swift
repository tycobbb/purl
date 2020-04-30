import AppKit

// -- types --
protocol Identifiable {
  static var name: String { get }
}

// -- impls --
extension Identifiable {
  static var name: String {
    return String(describing: self)
  }

  static var identifier: NSUserInterfaceItemIdentifier {
    return NSUserInterfaceItemIdentifier(name)
  }
}
