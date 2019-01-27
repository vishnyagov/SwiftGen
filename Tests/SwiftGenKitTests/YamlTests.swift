//
// SwiftGenKit UnitTests
// Copyright © 2019 SwiftGen
// MIT Licence
//

import PathKit
@testable import SwiftGenKit
import XCTest

class YamlTests: XCTestCase {
  func testEmpty() {
    let parser = Yaml.Parser()

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "empty", sub: .yaml)
  }

  func testSequence() throws {
    let parser = Yaml.Parser()
    try parser.searchAndParse(path: Fixtures.path(for: "grocery-list.yaml", sub: .yamlGood))

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "grocery-list", sub: .yaml)
  }

  func testMapping() throws {
    let parser = Yaml.Parser()
    try parser.searchAndParse(path: Fixtures.path(for: "mapping.yaml", sub: .yamlGood))

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "mapping", sub: .yaml)
  }

  func testJSON() throws {
    let parser = JSON.Parser()
    try parser.searchAndParse(path: Fixtures.path(for: "configuration.json", sub: .yamlGood))

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "configuration", sub: .yaml)
  }

  func testScalar() throws {
    let parser = Yaml.Parser()
    try parser.searchAndParse(path: Fixtures.path(for: "version.yaml", sub: .yamlGood))

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "version", sub: .yaml)
  }

  func testMutlipleDocuments() throws {
    let parser = Yaml.Parser()
    try parser.searchAndParse(path: Fixtures.path(for: "documents.yaml", sub: .yamlGood))

    let result = parser.stencilContext()
    XCTDiffContexts(result, expected: "documents", sub: .yaml)
  }

  func testDirectoryInput() {
    do {
      let parser = Yaml.Parser()
      let filter = try Filter(pattern: "[^/]*\\.(json|ya?ml)$")
      parser.searchAndParse(path: Fixtures.directory(sub: .yamlGood), filter: filter)

      let result = parser.stencilContext()
      XCTDiffContexts(result, expected: "all", sub: .yaml)
    } catch let error {
      XCTFail("Unexpected error occured while parsing: \(error)")
    }
  }

  func testFileWithBadSyntax() {
    do {
      _ = try Yaml.Parser().searchAndParse(path: Fixtures.path(for: "syntax.yaml", sub: .yamlBad))
      // The parser won't fail for unknown exceptions (it'll log it)
    } catch let error {
      XCTFail("Unexpected error occured while parsing: \(error)")
    }
  }
}
