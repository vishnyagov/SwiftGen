//
//  StylesContext.swift
//  swiftgen
//
//  Created by Владимир Вишнягов on 06/05/2019.
//  Copyright © 2019 AliSoftware. All rights reserved.
//

import Foundation

//
// See the documentation file for a full description of this context's structure:
// Documentation/SwiftGenKit Contexts/Colors.md
//

extension Styles.Parser {
  public func stencilContext() -> [String: Any] {
    let styleKits: [[String: Any]] = self.styles
      .sorted { $0.name < $1.name }
      .map { styleKit in
        let styles = styleKit.styles
          .sorted { $0.key < $1.key }
          .map(map(styleKit:value:))
        
        return [
          "name": styleKit.name,
          "styles": styles
        ]
    }
    
    return [
      "styles": styleKits
    ]
  }
  
  private func map(styleKit name: String, value: String) -> [String: String] {
    return [
      "name": name,
      "value": value
    ]
  }
}

