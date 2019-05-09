//
//  MarkdownDocumentViewController.swift
//  Mark Viewer
//
//  Created by Nelson Dai on 2019/5/7.
//  Copyright © 2019 Nelson Tai. All rights reserved.
//

import UIKit

protocol MarkdownDocumentViewControllerDelegate: AnyObject {
    func documentViewController(_ viewController: MarkdownDocumentViewController, didClickOn url: URL)
}

final class MarkdownDocumentViewController: UIViewController {
    private var markdownView: MarkdownWrapperView!
    var document: MarkdownDocument?
    weak var delegate: MarkdownDocumentViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        markdownView = MarkdownWrapperView(frame: .zero)
        view.addSubview(markdownView)

        markdownView.translatesAutoresizingMaskIntoConstraints = false
        markdownView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        markdownView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        markdownView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        markdownView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true

        markdownView.openURLHandler = { [weak self] url in
            guard let self = self else { return }
            self.delegate?.documentViewController(self, didClickOn: url)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard let doc = document else {
            fatalError("*** No Document Found! ***")
        }

        doc.open { [weak self, weak doc] (success) in
            guard success else {
                fatalError("*** Unable to open the text or markdown file ***")
            }
            guard let self = self, let doc = doc else { return }
            self.markdownView.update(markdownString: doc.rawString)
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.document?.close(completionHandler: nil)
    }
}
