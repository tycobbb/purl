class Signal<T> {
  typealias Observer = (T) -> Void

  // -- props --
  private var observers: [Observer] = []

  // -- commands --
  func push(_ next: T) {
    for observer in observers {
      observer(next)
    }
  }

  // -- queries --
  func on(_ observer: @escaping Observer) {
    observers.append(observer)
  }

  // -- factories --
  static func create(producer: (@escaping Observer) -> Void) -> Signal<T> {
    let signal = Signal()
    producer(signal.push)
    return signal
  }
}
