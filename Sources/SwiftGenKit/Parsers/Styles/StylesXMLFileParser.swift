//
// SwiftGenKit
// Copyright © 2019 SwiftGen
// MIT Licence
//

import Foundation
import Kanna
import PathKit

extension Styles {
  final class XMLFileParser: StylesFileTypeParser {
    static let extensions = ["xml"]

    private enum XML {
      static let styleXPath = "/resources/style"
      static let nameAttribute = "name"
    }

    func parseFile(at path: Path) throws -> StyleKit {
      let document: Kanna.XMLDocument
      do {
        document = try Kanna.XML(xml: path.read(), encoding: .utf8)
      } catch let error {
        throw ParserError.invalidFile(path: path, reason: "XML parser error: \(error).")
      }

      var styles = [String: String]()

      for style in document.xpath(XML.styleXPath) {
        guard let value = style.text else {
          throw ParserError.invalidFile(path: path, reason: "Invalid structure, color must have a value.")
        }
        guard let name = style["name"], !name.isEmpty else {
          throw ParserError.invalidFile(path: path, reason: "Invalid structure, color \(value) must have a name.")
        }

        styles[name] = try Styles.parse(name: name, value: value, path: path)
      }

      let name = path.lastComponentWithoutExtension
      return StyleKit(name: name, styles: styles)
    }
  }
}
