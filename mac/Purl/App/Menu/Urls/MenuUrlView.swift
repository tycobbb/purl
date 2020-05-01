import Cocoa

class MenuUrlView: NSCollectionViewItem, Configurable, Identifiable {
  // -- constants --
  static let height: CGFloat = 40.0

  // -- outlets --
  @IBOutlet
  private var initial: NSTextField!

  @IBOutlet
  private var cleaned: NSTextField!

  // -- Configurable --
  func configure(with model: Purl.Url) {
    self.initial.stringValue = model.initial
    self.cleaned.stringValue = (try? model.cleaned?.get()) ?? ""
  }
}
