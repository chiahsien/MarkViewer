//
//  SettingDefinitions.swift
//  Mark Viewer
//
//  Created by Nelson Dai on 2019/5/20.
//  Copyright © 2019 Nelson Tai. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let MarkdownViewSyntaxHighlightSettingDidChange = Notification.Name("MarkdownViewSyntaxHighlightSettingDidChange")
}

struct SettingKey {
    static let syntaxHighlight = "MarkdownViewSyntaxHighlight"
}
