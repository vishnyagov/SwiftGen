//
// SwiftGenKit
// Copyright © 2019 SwiftGen
// MIT Licence
//

import Foundation
import PathKit

public protocol Parser {
  init(options: [String: Any], warningHandler: MessageHandler?) throws

  // regex for the default filter
  static var defaultFilter: String { get }

  // Parsing and context generation
  func parse(path: Path, relativeTo parent: Path) throws
  func stencilContext() -> [String: Any]

  /// This callback will be called when a Parser want to emit a diagnostics message
  /// You can set this on the usage-site to a closure that prints the diagnostics in any way you see fit
  /// Arguments are (message, file, line)
  typealias MessageHandler = (String, String, UInt) -> Void
  var warningHandler: MessageHandler? { get set }
}

public extension Parser {
  func searchAndParse(paths: [Path], filter: Filter) {
    for path in paths {
      searchAndParse(path: path, filter: filter)
    }
  }

  func searchAndParse(path: Path, filter: Filter) {
    if path.matches(filter: filter) {
      let parentDir = path.absolute().parent()
      tryAndParse(path: path, relativeTo: parentDir)
    } else {
      let dirChildren = path.iterateChildren(options: [.skipsHiddenFiles, .skipsPackageDescendants])
      let parentDir = path.absolute()

      for path in dirChildren where path.matches(filter: filter) {
        tryAndParse(path: path, relativeTo: parentDir)
      }
    }
  }

  private func tryAndParse(path: Path, relativeTo parent: Path) {
    do {
      try parse(path: path, relativeTo: parent)
    } catch {
      self.warningHandler?("error: \(error)", #file, #line)
    }
  }
}
