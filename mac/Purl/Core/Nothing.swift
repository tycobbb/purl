// A type that represents no value and is never equal to anything.
struct Nothing: Equatable {
  // -- constants --
  static let nothing = Nothing()

  // -- Equatable --
  static func == (lhs: Self, rhs: Self) -> Bool {
    return false
  }
}
