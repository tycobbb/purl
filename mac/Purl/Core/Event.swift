import Cocoa

public struct Event {
  // -- props --
  let mask: NSEvent.EventTypeMask

  // -- lifetime --
  init(_ mask: NSEvent.EventTypeMask) {
    self.mask = mask
  }

  // -- queries --
  func signal() -> Signal<NSEvent> {
    return Signal.create { push in
      var monitor: Any? = nil
      monitor = NSEvent.addGlobalMonitorForEvents(matching: mask) { event in
        push(event)
      }

      return {
        if let monitor = monitor {
          NSEvent.removeMonitor(monitor)
        }
      }
    }
  }
}
