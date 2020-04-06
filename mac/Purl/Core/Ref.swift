final class Ref<T> {
  // -- props --
  private let value: T

  // -- lifetime --
  private init(_ value: T) {
    self.value = value
  }

  // -- factories --
  static func toRaw(_ value: T) -> UnsafeMutableRawPointer {
    return Unmanaged.passRetained(Ref(value)).toOpaque()
  }

  static func fromRaw(_ raw: UnsafeMutableRawPointer) -> T {
    return Unmanaged<Ref<T>>.fromOpaque(raw).takeRetainedValue().value
  }
}
