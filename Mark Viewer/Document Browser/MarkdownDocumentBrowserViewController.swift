//
//  MarkdownDocumentBrowserViewController.swift
//  Mark Viewer
//
//  Created by Nelson Dai on 2019/5/7.
//  Copyright © 2019 Nelson Tai. All rights reserved.
//

import UIKit

final class MarkdownDocumentBrowserViewController: UIDocumentBrowserViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
        allowsDocumentCreation = false
        allowsPickingMultipleItems = false
    }

    // MARK: MarkdownDocument Presentation
    func presentDocument(at documentURL: URL) {
        let doc = MarkdownDocument(fileURL: documentURL)
        let coordinator = MarkdownDocumentViewCoordinator(document: doc)
        coordinator.delegate = self
        coordinator.loadViewIfNeeded()

        let transitionController = self.transitionController(forDocumentURL: documentURL)
        transitionController.targetView = coordinator.view
        transitionController.loadingProgress = doc.progress
        coordinator.transitionController = transitionController

        present(coordinator, animated: true, completion: nil)
    }
}

// MARK: MarkdownDocumentViewCoordinatorDelegate
extension MarkdownDocumentBrowserViewController: MarkdownDocumentViewCoordinatorDelegate {
    func coordinatorDidFinish(_ coordinator: MarkdownDocumentViewCoordinator) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: UIDocumentBrowserViewControllerDelegate
extension MarkdownDocumentBrowserViewController: UIDocumentBrowserViewControllerDelegate {
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didPickDocumentsAt documentURLs: [URL]) {
        guard let sourceURL = documentURLs.first else { return }
        presentDocument(at: sourceURL)
    }

    func documentBrowser(_ controller: UIDocumentBrowserViewController, didImportDocumentAt sourceURL: URL, toDestinationURL destinationURL: URL) {
        presentDocument(at: destinationURL)
    }

    func documentBrowser(_ controller: UIDocumentBrowserViewController, failedToImportDocumentAt documentURL: URL, error: Error?) {
        let alert = UIAlertController(
            title: "Unable to Import Document",
            message: "An error occurred while trying to import a document: \(error?.localizedDescription ?? "Unknown Error")",
            preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)

        alert.addAction(action)
        controller.present(alert, animated: true, completion: nil)
    }
}
