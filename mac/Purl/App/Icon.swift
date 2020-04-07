import Cocoa

final class Icon: NSView, CAAnimationDelegate {
  // -- props
  private let isLoading: State<Bool>

  // -- props/layers
  private let outer = CAShapeLayer()
  private let inner = CAShapeLayer()

  // -- lifetime --
  required init?(coder: NSCoder) {
    fatalError()
  }

  required init(
    frame: NSRect,
    state: State<Bool> = CleanUrl.get().isLoading
  ) {
    isLoading = state

    super.init(frame: frame)

    render()
    isLoading.observe { [weak self] isLoading in
      if isLoading {
        self?.startAnimating()
      }
    }
  }

  private func render() {
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

  // -- animation --
  private func startAnimating() {
    rotate()
  }

  private func rotate() {
    let anim = CABasicAnimation(keyPath: "transform.rotation.z")
    anim.toValue = -CGFloat.pi * 2
    anim.duration = 1.5
    anim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
    anim.delegate = self

    inner.add(anim, forKey: nil)
  }

  // -- animation/CAAnimationDelegate
  func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    if isLoading.value {
      rotate()
    }
  }
}
