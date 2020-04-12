final class State<T: Equatable>: Signal<T> {
  // -- props --
  private(set) var value: T

  // -- lifetime --
  init(_ initial: T, disposal: Disposal? = nil) {
    value = initial
    super.init(disposal: disposal)
  }

  // -- commands --
  override func push(_ next: T) {
    if value != next {
      value = next
      super.push(value)
    }
  }

  // -- queries --
  @discardableResult
  override func on(_ observer: @escaping (T) -> Void) -> Self {
    observer(value)
    super.on(observer)
    return self
  }
}
