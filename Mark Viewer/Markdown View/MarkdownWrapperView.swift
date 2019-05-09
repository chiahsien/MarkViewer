//
//  MarkdownView.swift
//  Mark Viewer
//
//  Created by Nelson on 2019/5/8.
//  Copyright © 2019 Nelson Tai. All rights reserved.
//

import UIKit

final class MarkdownWrapperView: UIView {
    private var markdownView: MarkdownView!

    override convenience init(frame: CGRect) {
        self.init(frame: frame, markdownString: "")
    }

    init(frame: CGRect, markdownString: String) {
        super.init(frame: frame)

        let mdView = MarkdownView(frame: frame)
        addSubview(mdView)

        mdView.translatesAutoresizingMaskIntoConstraints = false
        mdView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        mdView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        mdView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        mdView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        markdownView = mdView
        update(markdownString: markdownString)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(markdownString: String) {
        try? markdownView.update(markdownString: markdownString)
    }
}
