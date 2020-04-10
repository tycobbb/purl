// -- types --
enum Request<T> {
  case loading
  case complete(Result<T, AnyError>)
}

// -- impls --
extension Request: Equatable where T: Equatable {
  static func ==(lhs: Request<T>, rhs: Request<T>) -> Bool {
    switch (lhs, rhs) {
    case (.loading, .loading):
      return true
    case (.complete(let lhs), .complete(let rhs)):
      return lhs == rhs
    default:
      return false
    }
  }
}
