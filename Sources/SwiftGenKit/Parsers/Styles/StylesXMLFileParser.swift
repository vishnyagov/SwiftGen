//
// SwiftGenKit
// Copyright © 2019 SwiftGen
// MIT Licence
//

import Foundation
import Kanna
import PathKit

//<item name=“textSize”>18sp</item>
//<item name=“fontFamily”>sans-serif</item>
//<item name=“textStyle”>bold</item>
//<item name=“letterSpacing”>0.03</item>
//<item name=“lineSpacingExtra”>6sp</item>
//<item name=“textColor”>@color/grey_text_87</item>

extension Styles {
  final class XMLFileParser: StylesFileTypeParser {
    static let extensions = ["xml"]

    private enum XML {
      static let styleXPath = "/resources/style"
      static let itemXPath = "item"
      static let nameAttribute = "name"
      static let textSizeAttribute = "textSize"
      static let fontFamilyAttribute = "fontFamily"
      static let textStyleAttribute = "textStyle"
      static let letterSpacingAttribute = "letterSpacing"
      static let lineSpacingExtraAttribute = "lineSpacingExtra"
      static let textColorAttribute = "textColor"
    }

    func parseFile(at path: Path) throws -> StyleKit {
      let document: Kanna.XMLDocument
      do {
        document = try Kanna.XML(xml: path.read(), encoding: .utf8)
      } catch let error {
        throw ParserError.invalidFile(path: path, reason: "XML parser error: \(error).")
      }
      var styles = [String: StyleKit]()
      for style in document.xpath(XML.styleXPath) {
        guard let name = style[XML.nameAttribute], !name.isEmpty else {
          throw ParserError.invalidFile(path: path, reason: "Invalid structure, style must have a name.")
        }
        var values = [String: String]()
        for value in style.xpath(XML.itemXPath) {
           guard let name = value[XML.nameAttribute] else { continue }
           values[name] = value.text
        }
        guard let textSize = values[XML.textSizeAttribute], !textSize.isEmpty else {
            throw ParserError.invalidFile(path: path, reason: "Invalid structure, style must have a \(XML.textSizeAttribute)).")
        }
        guard let fontFamily = values[XML.fontFamilyAttribute], !fontFamily.isEmpty else {
            throw ParserError.invalidFile(path: path, reason: "Invalid structure, style must have a \(XML.fontFamilyAttribute).")
        }
        guard let textStyle = values[XML.textStyleAttribute], !textStyle.isEmpty else {
            throw ParserError.invalidFile(path: path, reason: "Invalid structure, style must have a \(XML.textStyleAttribute).")
        }
        guard let textColor = values[XML.textColorAttribute], !textColor.isEmpty else {
            throw ParserError.invalidFile(path: path, reason: "Invalid structure, style must have a \(XML.textColorAttribute).")
        }
        styles[name] = StyleKit(name: name,
                                textSize: textSize,
                                fontFamily: fontFamily,
                                textStyle: textStyle,
                                textColor: textColor,
                                styles: [:])
      }
      let name = path.lastComponentWithoutExtension
      return StyleKit(name: name, styles: styles)
    }
  }
}
