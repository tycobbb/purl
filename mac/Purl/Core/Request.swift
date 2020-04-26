// -- types --
enum Request<T, E: Error> {
  case loading
  case complete(Result<T, E>)
}

// -- impls --
extension Request: Equatable where T: Equatable {
  static func ==(lhs: Request<T, E>, rhs: Request<T, E>) -> Bool {
    switch (lhs, rhs) {
    case (.loading, .loading):
      return true
    case (.complete(.success(let lhs)), .complete(.success(let rhs))):
      return lhs == rhs
    default:
      return false
    }
  }
}
