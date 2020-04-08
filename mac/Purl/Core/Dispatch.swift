import Foundation

func delay(seconds: Double, queue: DispatchQueue = .main, execute: @escaping () -> Void) {
  queue.asyncAfter(deadline: .now() + seconds, execute: execute)
}
