enum Raw<T: AnyObject> {
  // -- factories --
  static func wrap(_ value: T, isRetained: Bool = true) -> UnsafeMutableRawPointer {
    let unmanaged: Unmanaged = isRetained ? .passRetained(value) : .passUnretained(value)
    let raw = unmanaged.toOpaque()
    return raw
  }

  static func unwrap(_ ptr: UnsafeMutableRawPointer, isRetained: Bool = true) -> T {
    let unmanaged = Unmanaged<T>.fromOpaque(ptr)
    let ref = isRetained ? unmanaged.takeRetainedValue() : unmanaged.takeUnretainedValue()
    return ref
  }
}
