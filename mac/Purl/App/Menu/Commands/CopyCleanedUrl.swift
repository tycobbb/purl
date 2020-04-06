class CopyCleanedUrl: MenuCommand {
  // -- MenuCommand --
  func call() {
    print("clean url...")
  }

  // -- factories --
  static func item() -> MenuItem {
    return MenuItem(title: "Copy & Clean URL", command: CopyCleanedUrl())
  }
}
