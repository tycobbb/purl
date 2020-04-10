import Cocoa

// -- types --
protocol Vector2 {
  var x: CGFloat { get }
  var y: CGFloat { get }

  init(x: CGFloat, y: CGFloat)
}

struct Offset: Vector2 {
  var x: CGFloat = 0.0
  var y: CGFloat = 0.0

  init(x: CGFloat = 0.0, y: CGFloat = 0.0) {
    self.x = x
    self.y = y
  }
}

// -- impls --
// -- impls/Vector2
extension Vector2 {
  // -- lifetime --
  init(_ vec: Vector2) {
    self.init(x: vec.x, y: vec.y)
  }

  // -- queries --
  var min: CGFloat {
    return Swift.min(x, y)
  }

  // -- operators --
  static func + (vec: Self, other: Vector2) -> Self {
    return .init(
      x: vec.x + other.x,
      y: vec.y + other.y
    )
  }

  static func - (vec: Self, other: Vector2) -> Self {
    return .init(
      x: vec.x - other.x,
      y: vec.y - other.y
    )
  }

  static func * (vec: Self, factor: CGFloat) -> Self {
    return .init(
      x: vec.x * factor,
      y: vec.y * factor
    )
  }

  static func * (vec: Self, other: Vector2) -> Self {
    return .init(
      x: vec.x * other.x,
      y: vec.y * other.y
    )
  }

  static func / (vec: Self, divisor: CGFloat) -> Self {
    return .init(
      x: vec.x / divisor,
      y: vec.y / divisor
    )
  }

  static func / (vec: Self, other: Vector2) -> Self {
    return .init(
      x: vec.x / other.x,
      y: vec.y / other.y
    )
  }

  // -- factories --
  static func square(_ size: CGFloat) -> Self {
    return .init(
      x: size,
      y: size
    )
  }

  // -- conversions --
  func into<V1: Vector2>() -> V1 {
    return .init(
      x: x,
      y: y
    )
  }
}

// -- impls/CGRect
extension CGRect {
  // -- queries --
  var center: CGPoint {
    return point(x: 0.5, y: 0.5)
  }

  func point(x: CGFloat, y: CGFloat) -> CGPoint {
    return CGPoint(
      x: origin.x + size.x * x,
      y: origin.y + size.y * y
    )
  }

  func point(r: CGFloat, Θ angle: CGFloat) -> CGPoint {
    return center + CGPoint(
      x: r * cos(angle),
      y: r * sin(angle)
    )
  }

  // -- factories --
  static func centered<V1: Vector2, V2: Vector2>(at center: V1, size: V2) -> Self {
    return NSRect(
      origin: (center - size / 2).into(),
      size:   size.into()
    )
  }
}

// -- impls/conformance
extension CGPoint: Vector2 {
}

extension CGSize: Vector2 {
  // -- props --
  var x: CGFloat { width }
  var y: CGFloat { height }

  // -- lifetime --
  init(x: CGFloat, y: CGFloat) {
    self.init(width: x, height: y)
  }
}
