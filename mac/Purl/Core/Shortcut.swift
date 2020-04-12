import Carbon

final class Shortcut {
  // -- props --
  private let signal: Signal<()> = Signal()
  private var key: EventHotKeyRef?
  private var handler: EventHandlerRef?

  // -- lifetime --
  deinit {
    unregister()
  }

  // -- commands --
  func listen() -> Signal<()> {
    var status: OSStatus

    // register key
    if key == nil {
      status = RegisterEventHotKey(
        UInt32(kVK_ANSI_C),
        UInt32(cmdKey),
        id(),
        GetEventDispatcherTarget(),
        0,
        &key
      )

      if !check(status) {
        unregister()
      }
    }

    // register handler
    if handler == nil {
      status = InstallEventHandler(
        GetEventDispatcherTarget(),
        purl_didReceiveHotKeyEvent,
        1,
        [EventTypeSpec(eventClass: OSType(kEventClassKeyboard), eventKind: UInt32(kEventHotKeyPressed))],
        Raw.wrap(self, isRetained: false),
        &handler
      )

      if !check(status) {
        unregister()
      }
    }

    return signal
  }

  func handle(_ event: EventRef) -> OSStatus {
    if let error = validate(event: event) {
      return error
    }

    signal.push(())
    return OSStatus(eventNotHandledErr)
  }

  private func unregister() {
    if key != nil, check(UnregisterEventHotKey(key)) {
      key = nil
    }

    if handler != nil, check(RemoveEventHandler(handler)) {
      handler = nil
    }
  }

  // -- commands/helpers
  private func id() -> EventHotKeyID {
    var signature: OSType = 0
    for char in "purl".utf16 {
      signature = (signature << 8) + OSType(char)
    }

    return EventHotKeyID(signature: signature, id: 0)
  }

  private func validate(event: EventRef) -> OSStatus? {
    var other = EventHotKeyID()
    let error = GetEventParameter(
      event,
      EventParamName(kEventParamDirectObject),
      EventParamType(typeEventHotKeyID),
      nil,
      MemoryLayout<EventHotKeyID>.size,
      nil,
      &other
    )

    if error != noErr {
      return error
    }

    if other.signature != id().signature {
      return OSStatus(eventNotHandledErr)
    }

    if GetEventKind(event) != UInt32(kEventHotKeyPressed) {
      return OSStatus(eventNotHandledErr)
    }

    return nil
  }

  private func check(_ status: OSStatus?) -> Bool {
    if let status = status, status != noErr {
      print("status error: \(status)")
      return false
    }

    return true
  }
}

private func purl_didReceiveHotKeyEvent(call: EventHandlerCallRef?, event: EventRef?, data: UnsafeMutableRawPointer?) -> OSStatus {
  guard
    let event = event,
    let data = data else {
      return OSStatus(eventNotHandledErr)
    }

  let shortcut = Raw<Shortcut>.unwrap(data, isRetained: false)
  let status = shortcut.handle(event)

  return status
}
