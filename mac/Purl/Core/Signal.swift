final class Signal<T: Equatable> {
  typealias Observer = (T) -> Void

  // -- props --
  var value: T {
    didSet {
      if value != oldValue {
        didChangeValue()
      }
    }
  }

  // -- props/internal
  private var observers: [Observer] = []

  // -- lifetime --
  init(_ initial: T) {
    value = initial
  }

  // -- queries --
  func observe(observer: @escaping Observer) {
    observers.append(observer)
    observer(value)
  }

  // -- events --
  private func didChangeValue() {
    for observer in observers {
      observer(value)
    }
  }
}
