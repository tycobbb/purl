final class Purl {
  func cleanUrl(_ initial: String) -> String? {
    guard let cleaned = purl_clean_url(initial) else {
      return nil
    }

    let url = String(cString: cleaned)
    purl_free_url(cleaned)

    return url
  }
}
