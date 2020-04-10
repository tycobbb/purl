struct Cast<T> {
  static func from<U>(_ value: U) -> T? {
    return value as? T
  }
}
