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
        
        // Access the document
        document?.open(completionHandler: { (success) in
            if success {
                // Display the content of the document, e.g.:
                guard let rawString = self.document?.rawString else {
                    return
                }
                self.markdownView.update(markdownString: rawString)
                self.title = self.document?.fileURL.lastPathComponent
            } else {
                // Make sure to handle the failed import appropriately, e.g., by presenting an error message to the user.
            }
        })
    }
    
    func closeDocumentViewController() {
        self.document?.close(completionHandler: nil)
    }
}
