//
//  MarkdownDocument.swift
//  Mark Viewer
//
//  Created by Nelson Dai on 2019/5/7.
//  Copyright © 2019 Nelson Tai. All rights reserved.
//

import UIKit
import Down

enum MarkdownDocumentError: Error {
    case unableToParseText
    case unableToEncodeText
}

final class MarkdownDocument: UIDocument {
    private(set) var rawString = ""
    var htmlString: String {
        get {
            let down = Down(markdownString: rawString)
            let html = try? down.toHTML()
            return html ?? ""
        }
    }

    override func contents(forType typeName: String) throws -> Any {
        guard let data = rawString.data(using: .utf8) else {
            throw MarkdownDocumentError.unableToEncodeText
        }
        return data as Any
    }

    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        guard let data = contents as? Data else {
            // This would be a developer error.
            fatalError("*** \(contents) is not an instance of NSData.***")
        }
        guard let text = String(data: data, encoding: .utf8) else {
            throw MarkdownDocumentError.unableToParseText
        }
        rawString = text
    }
}
