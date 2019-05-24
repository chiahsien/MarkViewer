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
    private var browserTransition: MarkdownDocumentBrowserTransitioningDelegate?
    private var nav: UINavigationController!
    private var documentVC: MarkdownDocumentViewController!
    private weak var syntaxVC: SyntaxHighlightViewController?

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

    override func viewDidLoad() {
        super.viewDidLoad()

        documentVC = MarkdownDocumentViewController()
        nav = UINavigationController(rootViewController: documentVC)
        addChild(nav)
        view.addSubview(nav.view)
        nav.didMove(toParent: self)
    }

    func openDocument(_ document: MarkdownDocument, completion: ((Bool) -> Void)? = nil) {
        documentVC.openDocument(document) { [unowned self] (success) in
            self.documentVC.delegate = self
            self.createNavigationItemsFor(viewController: self.documentVC)
            completion?(success)
        }
    }
}

extension MarkdownDocumentViewCoordinator: MarkdownDocumentViewControllerDelegate {
    // MARK: MarkdownDocumentViewControllerDelegate
    func documentViewController(_ viewController: MarkdownDocumentViewController, didClickOn url: URL) {
        guard let scheme = url.scheme?.lowercased() else { return }

        if scheme == "http" || scheme == "https" {
            let safari = SFSafariViewController(url: url)
            present(safari, animated: true, completion: nil)
        } else if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            let alert = UIAlertController(title: "Unsupported URL", message: url.absoluteString, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }

    // MARK: Private Functions for MarkdownDocumentViewController
    private func createNavigationItemsFor(viewController: MarkdownDocumentViewController) {
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        viewController.navigationItem.leftBarButtonItem = doneItem

        let titleLabel = UILabel()
        titleLabel.text = viewController.title
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        viewController.navigationItem.titleView = titleLabel

        let settingItem = UIBarButtonItem(image: UIImage(imageLiteralResourceName: "Setting"), style: .plain, target: self, action: #selector(showSettings))
        viewController.navigationItem.rightBarButtonItems = [settingItem]
    }

    @objc private func done() {
        documentVC.closeDocument { [unowned self] (_) in
            self.delegate?.coordinatorDidFinish(self)
        }
    }

    @objc private func showSettings() {
        let vc = SyntaxHighlightViewController()
        createNavigationItemsFor(viewController: vc)
        nav.pushViewController(vc, animated: true)
        syntaxVC = vc
    }
}

private extension MarkdownDocumentViewCoordinator {
    // MARK: Private Functions for SyntaxHighlightViewController
    func createNavigationItemsFor(viewController: SyntaxHighlightViewController) {
        let saveItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveSetting))
        viewController.navigationItem.rightBarButtonItem = saveItem
    }
    @objc func saveSetting() {
        syntaxVC?.saveSetting()
        nav.popViewController(animated: true)
    }
}
