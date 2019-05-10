//
//  MarkdownDocumentViewCoordinator.swift
//  Mark Viewer
//
//  Created by Nelson Dai on 2019/5/8.
//  Copyright © 2019 Nelson Tai. All rights reserved.
//

import UIKit
import SafariServices

protocol MarkdownDocumentViewCoordinatorDelegate: AnyObject {
    func coordinatorDidFinish(_ coordinator: MarkdownDocumentViewCoordinator)
}

final class MarkdownDocumentViewCoordinator: UIViewController {
    private var document: MarkdownDocument!
    private var nav: UINavigationController!
    private var browserTransition: MarkdownDocumentBrowserTransitioningDelegate?

    weak var delegate: MarkdownDocumentViewCoordinatorDelegate?
    var transitionController: UIDocumentBrowserTransitionController? {
        didSet {
            if let controller = transitionController {
                modalPresentationStyle = .custom
                browserTransition = MarkdownDocumentBrowserTransitioningDelegate(withTransitionController: controller)
                transitioningDelegate = browserTransition
            } else {
                modalPresentationStyle = .none
                browserTransition = nil
                transitioningDelegate = nil
            }
        }
    }

    init(document: MarkdownDocument) {
        self.document = document
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let vc = MarkdownDocumentViewController()
        vc.document = document
        vc.delegate = self

        nav = UINavigationController(rootViewController: vc)
        addChild(nav)
        view.addSubview(nav.view)
        nav.didMove(toParent: self)

        createNavigationItemsFor(viewController: vc)
    }

    private func createNavigationItemsFor(viewController: UIViewController) {
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        viewController.navigationItem.leftBarButtonItem = doneItem

        let titleLabel = UILabel()
        titleLabel.text = document.fileURL.lastPathComponent
        titleLabel.lineBreakMode = .byTruncatingTail
        viewController.navigationItem.titleView = titleLabel

        let space = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        space.width = 60
        viewController.navigationItem.rightBarButtonItems = [space]
    }

    @objc private func done() {
        delegate?.coordinatorDidFinish(self)
    }
}

extension MarkdownDocumentViewCoordinator: MarkdownDocumentViewControllerDelegate {
    func documentViewController(_ viewController: MarkdownDocumentViewController, didClickOn url: URL) {
        guard let scheme = url.scheme?.lowercased() else { return }

        if scheme == "http" || scheme == "https" {
            let safari = SFSafariViewController(url: url)
            nav.present(safari, animated: true, completion: nil)
        } else if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            let alert = UIAlertController(title: "Unsupported URL", message: url.absoluteString, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
}
