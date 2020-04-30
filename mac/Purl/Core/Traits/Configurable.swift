// -- types --
protocol Configurable {
  associatedtype Model
  
  // -- commands --
  func configure(with model: Model)
}

// -- impls --
extension Configurable where Self: Instantiable {
  static func instance(with model: Model) -> Self {
    let instance = self.instance()
    instance.configure(with: model)
    return instance
  }
}
