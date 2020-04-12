// -- types --
protocol SingleMarker: Service {}

extension Service {
  typealias Single = SingleMarker
}

// -- impls --
extension Service.Single {
  static func get() -> Self {
    return container.single(factory: make)
  }
}


