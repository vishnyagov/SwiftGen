//
// SwiftGenKit
// Copyright © 2019 SwiftGen
// MIT Licence
//

import Foundation
import PathKit

public enum Styles {
  public enum ParserError: Error, CustomStringConvertible {
    case invalidFile(path: Path, reason: String)
    case unsupportedFileType(path: Path, supported: [String])

    public var description: String {
      switch self {
      case .invalidFile(let path, let reason):
        return "error: Unable to parse file at \(path). \(reason)"
      case .unsupportedFileType(let path, let supported):
        return """
          error: Unsupported file type for \(path). \
          The supported file types are: \(supported.joined(separator: ", "))
          """
      }
    }
  }

  public final class Parser: SwiftGenKit.Parser {
    private var parsers = [String: StylesFileTypeParser.Type]()
    var styles = [StyleKit]()
    public var warningHandler: Parser.MessageHandler?

    private static let subParsers: [StylesFileTypeParser.Type] = [
      XMLFileParser.self
    ]

    public init(options: [String: Any] = [:], warningHandler: Parser.MessageHandler? = nil) {
      self.warningHandler = warningHandler

      for parser in Parser.subParsers {
        register(parser: parser)
      }
    }

    public static var defaultFilter: String {
      let extensions = Parser.subParsers.flatMap { $0.extensions }.sorted().joined(separator: "|")
      return "[^/]\\.(?i:\(extensions))$"
    }

    public func parse(path: Path, relativeTo parent: Path) throws {
      guard let parserType = parsers[path.extension?.lowercased() ?? ""] else {
        throw ParserError.unsupportedFileType(path: path, supported: parsers.keys.sorted())
      }

      let parser = parserType.init()
      let style = try parser.parseFile(at: path)
      styles += [style]
    }

    func register(parser: StylesFileTypeParser.Type) {
      for ext in parser.extensions {
        if let old = parsers[ext] {
          warningHandler?("""
            error: Parser \(parser) tried to register the file type '\(ext)' already \
            registered by \(old).
            """,
            #file,
            #line)
        }
        parsers[ext] = parser
      }
    }
  }
}
