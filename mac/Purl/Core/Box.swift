final class Ref<T> {
  // -- props --
  let value: T

  // -- lifetime --
  init(_ value: T) {
    self.value = value
  }

  // -- queries --
  func retained() -> UnsafeMutableRawPointer {
    return Unmanaged.passRetained(self).toOpaque()
  }

  // -- factories --
  static func fromRetained(_ retained: UnsafeMutableRawPointer) -> Self {
    return Unmanaged.fromOpaque(retained).takeRetainedValue()
  }
}
