final class Container {
  // -- containers --
  static let app = Container()

  // -- props --
  private var storage: [AnyHashable: Any] = [:]

  // -- commands --
  func single<T>(factory: () -> T) -> T {
    let key = String(describing: T.self)
    if let service = storage[key] as? T {
      return service
    }

    let service = factory()
    storage[key] = service

    return service
  }
}
