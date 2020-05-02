import Cocoa

final class HoverView: NSView {
  // -- props --
  private var isHovering: Bool = false {
    didSet {
      needsDisplay = true
    }
  }

  // -- view lifecycle --
  override func awakeFromNib() {
    super.awakeFromNib()

    addTrackingArea(.init(
      rect: .zero,
      options: [.inVisibleRect, .activeAlways, .mouseEnteredAndExited],
      owner: self,
      userInfo: nil
    ))
  }

  // -- events --
  override func mouseEntered(with event: NSEvent) {
    super.mouseEntered(with: event)
    isHovering = true
  }

  override func mouseExited(with event: NSEvent) {
    super.mouseExited(with: event)
    isHovering = false
  }

  // -- NSView --
  override var isOpaque: Bool {
    return isHovering
  }

  override func draw(_ rect: NSRect) {
    let color: NSColor = isHovering ? .controlAccentColor : .clear
    color.setFill()
    bounds.fill()
    super.draw(rect)
  }
}
