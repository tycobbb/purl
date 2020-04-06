// -- export --
extension Service {
  typealias Single = SingleMarker
}

// -- types --
protocol SingleMarker: Service {
}

// -- impls --
extension Service.Single {
  static func get() -> Self {
    return container.single(factory: make)
  }
}


