//
// SwiftGenKit
// Copyright © 2019 SwiftGen
// MIT Licence
//

import Foundation

protocol InterfaceBuilderSwiftType {
  var type: String { get }
  var module: String? { get }
  var moduleIsPlaceholder: Bool { get }
}
