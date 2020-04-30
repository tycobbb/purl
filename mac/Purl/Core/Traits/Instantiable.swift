import Cocoa

// -- types --
protocol Instantiable {
  static func instance() -> Self
}

protocol FromStoryboard: Instantiable, Identifiable {
  static func storyboard() -> NSStoryboard
}

// -- impls --
extension FromStoryboard {
  static func instance() -> Self {
    return instantiate()
  }

  static func storyboard() -> NSStoryboard {
    return storyboard(for: self)
  }

  // -- impls/utilities
  static func instantiate<T: FromStoryboard>(bundle: Bundle = .main) -> T {
    return T.storyboard().instantiateController(withIdentifier: name) as! T
  }

  static func storyboard<T: FromStoryboard>(for type: T.Type, bundle: Bundle = .main) -> NSStoryboard {
    return NSStoryboard(name: type.name, bundle: bundle)
  }
}
