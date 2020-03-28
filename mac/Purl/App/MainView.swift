import Cocoa

final class MainView: DropUrlDelegate {
  // -- deps --
  private let dropUrl: DropUrl

  // -- props --
  let view: NSStatusItem

  // -- props/subviews
  private let icon: Icon

  // -- lifetime --
  init(view: NSStatusItem, dropUrl: DropUrl = DropUrl()) {
    guard
      let button = view.button,
      let window = button.window else {
        fatalError("status item has no button to configure")
      }

    // assign deps/props
    self.view = view
    self.icon = Icon(frame: button.bounds)
    self.dropUrl = dropUrl

    // configure views
    button.addSubview(icon)
    window.registerForDraggedTypes([.URL, .string, .html])
    window.delegate = dropUrl
  }

  // -- DropUrlDelegate --
  func didChangeRequestState(to isLoading: Bool) {
    icon.isLoading = isLoading
  }

  // -- factories --
  static func addItem(toStatusBar statusBar: NSStatusBar) -> MainView {
    return MainView(
      view: statusBar.statusItem(withLength: NSStatusItem.squareLength)
    )
  }

  // -- children --
  private final class Icon: NSView, CAAnimationDelegate {
    // -- props --
    var isLoading: Bool = false {
      didSet {
        if isLoading && !oldValue {
          didBeginAnimation()
        }
      }
    }

    // -- props/layers
    private let outer = CAShapeLayer()
    private let inner = CAShapeLayer()

    // -- lifetime --
    required init?(coder: NSCoder) {
      super.init(coder: coder)
    }

    override init(frame: NSRect) {
      super.init(frame: frame)
      wantsLayer = true

      // style and add outer ring
      outer.lineWidth = 1.5
      outer.strokeColor = .white
      layer?.addSublayer(outer)

      // set position for outer ring
      let os: CGSize = .square(bounds.size.min * 0.65)
      let or: CGRect = .centered(at: bounds.center, size: os)

      outer.frame = or
      outer.path = CGPath(ellipseIn: outer.bounds, transform: nil)

      // style and add highlight
      inner.fillColor = .white
      layer?.addSublayer(inner)

      // set position of highlight
      let ohs: CGSize = .square(os.x * 0.6)
      let ohr: CGRect = .centered(at: bounds.center, size: ohs)
      inner.frame = ohr

      let ihs: CGSize = .square(os.x * 0.2)
      let ihr: CGRect = .centered(at: inner.bounds.point(r: ohs.x / 3, Θ: .pi / 4), size: ihs)
      inner.path = CGPath(ellipseIn: ihr, transform: nil)
    }

    // -- events --
    private func didBeginAnimation() {
      inner.add(makeRotation(), forKey: nil)
    }

    // -- events/CAAnimationDelegate
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
      if isLoading {
        inner.add(makeRotation(), forKey: nil)
      }
    }

    // -- events/helpers
    private func makeRotation() -> CAAnimation {
      let anim = CABasicAnimation(keyPath: "transform.rotation.z")
      anim.toValue = -CGFloat.pi * 2
      anim.duration = 1.5
      anim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
      anim.delegate = self
      return anim
    }
  }
}
