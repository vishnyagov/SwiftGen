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
    let textSize: String?
    let fontFamily: String?
    let textStyle: String?
    let textColor: String?
    let letterSpacing: String?
    let lineSpacingExtra: String?
    let styles: [String: StyleKit]
    
    init(name: String,
         textSize: String? = nil,
         fontFamily: String? = nil,
         textStyle: String? = nil,
         textColor: String? = nil,
         letterSpacing: String? = nil,
         lineSpacingExtra: String? = nil,
         styles: [String: StyleKit]) {
      self.name = name
      self.textSize = textSize
      self.fontFamily = fontFamily
      self.textStyle = textStyle
      self.textColor = textColor
      self.letterSpacing = letterSpacing
      self.lineSpacingExtra = lineSpacingExtra
      self.styles = styles
    }
  }
}

protocol StylesFileTypeParser: AnyObject {
  static var extensions: [String] { get }

  init()
  func parseFile(at path: Path) throws -> Styles.StyleKit
}

// MARK: - Private Helpers

extension Styles {
  static func parse(name: String, textSize: String, fontFamily: String, textStyle: String, textColor: String, path: Path) throws -> StyleKit {
    return StyleKit(name: name,
                    textSize: textSize,
                    fontFamily: fontFamily,
                    textStyle: textStyle,
                    textColor: textColor,
                    letterSpacing: nil,
                    lineSpacingExtra: nil,
                    styles: [:])
  }
}
