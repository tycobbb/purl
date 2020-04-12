class Signal<T> {
  typealias Observer = (T) -> Void
  typealias Disposal = () -> Void

  // -- props --
  private var observers: [Observer] = []
  private var disposal: Disposal?

  // -- lifetime --
  init(disposal: Disposal? = nil) {
    self.disposal = disposal
  }

  deinit {
    disposal?()
    disposal = nil
  }

  // -- commands --
  func push(_ next: T) {
    for observer in observers {
      observer(next)
    }
  }

  // -- queries --
  @discardableResult
  func on(_ observer: @escaping Observer) -> Self {
    observers.append(observer)
    return self
  }

  // -- factories --
  static func create(producer: (@escaping Observer) -> Disposal?) -> Signal<T> {
    let signal = Signal()
    signal.disposal = producer(signal.push)
    return signal
  }
}
