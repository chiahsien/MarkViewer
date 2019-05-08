//
//  MarkdownDocumentViewController.swift
//  Mark Viewer
//
//  Created by Nelson Dai on 2019/5/7.
//  Copyright © 2019 Nelson Tai. All rights reserved.
//

import UIKit

final class MarkdownDocumentViewController: UIViewController {
    private var markdownView: MarkdownView!
    var document: MarkdownDocument?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        markdownView = MarkdownView(frame: .zero)
        view.addSubview(markdownView)

        markdownView.translatesAutoresizingMaskIntoConstraints = false
        markdownView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        markdownView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        markdownView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        markdownView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard let doc = document else {
            fatalError("*** No Document Found! ***")
        }
        assert(doc.documentState.contains(.normal), "*** Open the document before displaying it. ***")

        markdownView.update(markdownString: doc.rawString)
        title = doc.fileURL.lastPathComponent
    }
    
    func closeDocumentViewController() {
        self.document?.close(completionHandler: nil)
    }
}
