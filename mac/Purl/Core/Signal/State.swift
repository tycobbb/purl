final class State<T: Equatable>: Signal<T> {
  // -- props --
  private(set) var value: T

  // -- lifetime --
  init(_ initial: T) {
    value = initial
    super.init()
  }

  // -- commands --
  override func push(_ next: T) {
    if value != next {
      value = next
      super.push(value)
    }
  }

  // -- queries --
  override func on(_ observer: @escaping (T) -> Void) {
    observer(value)
    super.on(observer)
  }
}
