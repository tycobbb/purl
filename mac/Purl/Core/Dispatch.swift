import Foundation

func delay(seconds: Double, queue: DispatchQueue = .main, execute: @escaping () -> Void) {
  queue.asyncAfter(deadline: .now() + seconds, execute: execute)
}

func every(seconds: Double, queue: DispatchQueue = .main) -> Signal<()> {
  return Signal.create { push in
    var stopped = false

    func wait() {
      if !stopped {
        delay(seconds: seconds, queue: queue, execute: execute)
      }
    }

    func execute() {
      if !stopped {
        push(())
        wait()
      }
    }

    wait()

    return {
      stopped = true
    }
  }
}
