// -- types --
protocol Service {
  static func make() -> Self
  static var container: Container { get }
}

// -- impls --
extension Service {
  static var container: Container {
    return .app
  }

  static func get() -> Self {
    return make()
  }
}
