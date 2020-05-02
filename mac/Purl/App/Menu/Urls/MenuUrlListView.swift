import Cocoa
import SwiftUI

final class MenuUrlListView: NSViewController, FromStoryboard {
  // -- deps --
  private var purl = Purl.get()

  // -- props --
  @IBOutlet
  private var list: NSCollectionView!

  @IBOutlet
  private var listHeight: NSLayoutConstraint!

  @IBOutlet
  private var listFallback: NSView!

  // -- NSViewController --
  override func viewDidLoad() {
    super.viewDidLoad()

    // register items
    list.register(MenuUrlView.self, forItemWithIdentifier: MenuUrlView.identifier)

    // configure view
    view.frame.size.width = 250.0

    // listen for changes
    purl.changes.on { [weak self] _ in
      self?.didUpdateUrls()
    }
  }

  override func updateViewConstraints() {
    super.updateViewConstraints()
    listHeight.constant = list.collectionViewLayout?.collectionViewContentSize.height ?? 0
  }

  override func viewWillLayout() {
    super.viewWillLayout()
    view.frame.size.height = view.fittingSize.height
  }

  // -- events --
  private func didUpdateUrls() {
    list.reloadData()
    view.needsUpdateConstraints = true

    let isListHidden = purl.size == 0
    listFallback.isHidden = !isListHidden
    list.enclosingScrollView?.isHidden = isListHidden
  }

  // -- factories --
  static func item() -> NSMenuItem {
    let view = self.instance()
    let item = NSMenuItem()
    item.view = view.view
    item.representedObject = view
    return item
  }
}

extension MenuUrlListView: NSCollectionViewDataSource {
  func collectionView(_ list: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
    return purl.size
  }

  func collectionView(_ list: NSCollectionView, itemForRepresentedObjectAt path: IndexPath) -> NSCollectionViewItem {
    let item = list.makeItem(withIdentifier: MenuUrlView.identifier, for: path) as! MenuUrlView
    item.configure(with: purl.url(purl.size - path.item - 1))
    return item
  }
}

extension MenuUrlListView: NSCollectionViewDelegateFlowLayout {
  func collectionView(_ list: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
    return NSSize(width: list.bounds.width, height: MenuUrlView.height)
  }
}
