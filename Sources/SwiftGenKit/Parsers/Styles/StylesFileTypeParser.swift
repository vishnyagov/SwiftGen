//
// SwiftGenKit
// Copyright © 2019 SwiftGen
// MIT Licence
//

import AppKit
import Foundation
import PathKit

extension Styles {
  struct StyleKit {
    let name: String
    let styles: [String: String]
  }
}

protocol StylesFileTypeParser: AnyObject {
  static var extensions: [String] { get }

  init()
  func parseFile(at path: Path) throws -> Styles.StyleKit
}

// MARK: - Private Helpers

extension Styles {
  static func parse(name: String, value: String, path: Path) throws -> String {
      return value
  }
}
