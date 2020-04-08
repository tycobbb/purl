import Cocoa

final class NotificationView: NSViewController {
  // -- props --
  private var url: String! {
    didSet {
      if isViewLoaded {
        configure()
      }
    }
  }

  // -- props/outlets
  @IBOutlet
  private var label: NSTextField!

  // -- lifecycle --
  override func viewDidLoad() {
    super.viewDidLoad()
    self.configure()
  }

  // -- commands --
  private func configure() {
    label.stringValue = url
  }

  // -- factories --
  static func instance(_ url: String) -> NotificationView {
    let storyboard = NSStoryboard(name: String(describing: self), bundle: .main)
    let controller = storyboard.instantiateInitialController() as! NotificationView
    controller.url = url
    return controller
  }
}
