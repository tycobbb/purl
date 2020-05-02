import Cocoa

class MenuUrlView: NSCollectionViewItem, Configurable, Identifiable {
  // -- constants --
  static let height: CGFloat = 36.0

  // -- outlets --
  @IBOutlet
  private var name: NSTextField!
  @IBOutlet
  private var info: NSTextField!

  // -- Configurable --
  func configure(with model: Purl.Url) {
    switch model.cleaned {
    case .success(let cleaned):
      name.stringValue = cleaned
      info.stringValue = "Original: \(model.initial)"
    case .failure(let error):
      name.stringValue = model.initial
      info.stringValue = "Error: \(error)"
    case .none:
      name.stringValue = model.initial
      info.stringValue = "Cleaning..."
    }
  }
}
