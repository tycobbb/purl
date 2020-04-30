import Cocoa

final class NotificationView: NSViewController, Configurable, FromStoryboard {
  // -- props --
  private var url: String! {
    didSet {
      if isViewLoaded {
        render()
      }
    }
  }

  // -- props/outlets
  @IBOutlet
  private var label: NSTextField!

  // -- lifecycle --
  override func viewDidLoad() {
    super.viewDidLoad()

    if self.url != nil {
      render()
    }
  }

  // -- layout --
  private func render() {
    label.stringValue = url
  }

  // -- Configurable --
  func configure(with model: String) {
    url = model
  }
}
