import Cocoa

final class Icon: NSView, CAAnimationDelegate {
  // -- props
  private let request: State<Request<String>?>

  // -- props/layers
  private let outer = CAShapeLayer()
  private let inner = CAShapeLayer()
  private let check = CAShapeLayer()

  // -- lifetime --
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  required init(
    frame: NSRect,
    state: State<Request<String>?> = AddUrl.get().request
  ) {
    request = state

    super.init(frame: frame)

    render()
    request.on { [weak self] request in
      if case .loading = request {
        self?.startAnimating()
      }
    }
  }

  private func render() {
    wantsLayer = true

    let center = bounds.center

    // style and add outer ring
    outer.lineWidth = 1.5
    outer.fillColor = .clear
    outer.strokeColor = .white
    layer?.addSublayer(outer)

    // set position for outer ring
    let os: CGSize = .square(bounds.size.min * 0.65)
    let or: CGRect = .centered(at: center, size: os)

    outer.frame = or
    outer.path = CGPath(ellipseIn: outer.bounds, transform: nil)

    // style and add highlight
    inner.fillColor = .white
    layer?.addSublayer(inner)

    // set position of highlight
    let ohs: CGSize = .square(os.x * 0.6)
    let ohr: CGRect = .centered(at: center, size: ohs)
    inner.frame = ohr

    let ihs: CGSize = .square(os.x * 0.2)
    let ihr: CGRect = .centered(at: inner.bounds.point(r: ohs.x / 3, Θ: .pi / 4), size: ihs)
    inner.path = CGPath(ellipseIn: ihr, transform: nil)

    // style and add check
    check.lineWidth = 2.0
    check.lineCap = .round
    check.fillColor = .clear
    check.strokeColor = CGColor(red: 0.204, green: 0.922, blue: 0.345, alpha: 1)
    check.strokeEnd = 0.0
    layer?.addSublayer(check)

    let cs: CGSize = .square(os.x * 0.50)
    let cr: CGRect = .centered(at: center + Offset(y: 1), size: cs)
    check.frame = cr

    let cb = check.bounds
    let cp = CGMutablePath()
    cp.move(to: cb.point(x: 0.0, y: 0.3))
    cp.addLine(to: cb.point(x: 0.3, y: 0.0))
    cp.addLine(to: cb.point(x: 1.0, y: 0.7))

    check.path = cp
  }

  // -- animation --
  enum Step: String {
    case rotate
    case success
    case revert

    static let key = ":purl:anim.step"
  }

  private func startAnimating() {
    rotate()
  }

  private func rotate() {
    animate(inner, "transform.rotation.z",
      to: -.pi * 2,
      duration: 1.5,
      step: .rotate
    )
  }

  private func success() {
    animate(inner, "opacity",
      to: 0.0,
      duration: 0.25,
      persists: true
    )

    animate(check, "strokeEnd",
      to: 1.0,
      duration: 0.25,
      persists: true,
      step: .success
    )
  }

  private func revert() {
    animate(inner, "opacity",
      to: 1.0,
      duration: 0.35,
      delay: 0.35,
      persists: true
    )

    animate(check, "opacity",
      to: 0.0,
      duration: 0.35,
      step: .revert
    )
  }

  private func reset() {
    inner.removeAllAnimations()
    check.removeAllAnimations()
  }

  // -- animation/CAAnimationDelegate
  func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    switch (request.value, step(fromAnim: anim)) {
    case (.loading, .rotate):
      rotate()
    case (.complete(.success(_)), .rotate):
      success()
    case (.complete(.success(_)), .success):
      delay(seconds: 1, execute: revert)
    case (.complete(.success(_)), .revert):
      reset()
    default: break
    }
  }

  // -- animation/helpers
  private func animate(
    _ layer: CALayer,
    _ prop: String,
    to value: CGFloat,
    duration: CFTimeInterval,
    delay: CFTimeInterval? = nil,
    persists: Bool = false,
    step: Step? = nil
  ) {
    let anim = CABasicAnimation(keyPath: prop)

    anim.delegate = self
    anim.toValue = value
    anim.duration = duration
    anim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

    if let delay = delay {
      anim.beginTime = CACurrentMediaTime() + delay
    }

    if persists {
      anim.isRemovedOnCompletion = false
      anim.fillMode = .forwards
    }

    if let step = step {
      anim.setValue(step.rawValue, forKey: Step.key)
    }

    layer.add(anim, forKey: nil)
  }

  private func step(fromAnim anim: CAAnimation) -> Step? {
    return anim.value(forKey: Step.key).flatMap(Cast<String>.from).flatMap(Step.init)
  }
}
