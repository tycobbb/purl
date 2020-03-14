import Cocoa

final class MainView {
  // -- deps --
  private let dropUrl: DropUrl

  // -- props --
  let view: NSStatusItem

  // -- lifetime --
  init(view: NSStatusItem, dropUrl: DropUrl = DropUrl()) {
    // assign deps/props
    self.view = view
    self.dropUrl = dropUrl

    // configure view
    guard let button = view.button, let window = button.window else {
      print("no status item button to configure")
      return
    }

    button.addSubview(Icon(frame: button.bounds))
    window.registerForDraggedTypes([.URL, .string, .html])
    window.delegate = dropUrl
  }

  // -- factories --
  static func addItem(toStatusBar statusBar: NSStatusBar) -> MainView {
    return MainView(
      view: statusBar.statusItem(withLength: NSStatusItem.squareLength)
    )
  }

  private final class Icon: NSView {
    required init?(coder: NSCoder) {
      super.init(coder: coder)
    }

    override init(frame: NSRect) {
      super.init(frame: frame)
      wantsLayer = true
    }

    override func draw(_ rect: NSRect) {
      super.draw(rect)

      let w = bounds.size.min * 0.65

      let os: CGSize = .square(w)
      let or: NSRect = .centered(at: bounds.center, size: os)

      let hs: CGSize = .square(w * 0.2)
      let hr: NSRect = .centered(at: or.point(x: 0.65, y: 0.65), size: hs)

      NSColor.white.set()

      let o = NSBezierPath(ovalIn: or)
      o.lineWidth = 1.5
      o.stroke()

      let h = NSBezierPath(ovalIn: hr)
      h.fill()
    }
  }
}
