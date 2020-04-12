final class Box<T> {
  // -- props --
  private let value: T

  // -- lifetime --
  private init(_ value: T) {
    self.value = value
  }

  // -- factories --
  static func wrap(_ value: T, isRetained: Bool = true) -> UnsafeMutableRawPointer {
    return Raw.wrap(Box(value), isRetained: isRetained)
  }

  static func unwrap(_ raw: UnsafeMutableRawPointer, isRetained: Bool = true) -> T {
    return Raw<Box<T>>.unwrap(raw, isRetained: isRetained).value
  }
}
