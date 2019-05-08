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

    ///
    /// !!! Not Implement Yet !!!
    ///
//    func documentBrowser(_ controller: UIDocumentBrowserViewController, didRequestDocumentCreationWithHandler importHandler: @escaping (URL?, UIDocumentBrowserViewController.ImportMode) -> Void) {
//        let newDocumentURL: URL? = nil
//
//        // Set the URL for the new document here. Optionally, you can present a template chooser before calling the importHandler.
//        // Make sure the importHandler is always called, even if the user cancels the creation request.
//        if newDocumentURL != nil {
//            importHandler(newDocumentURL, .move)
//        } else {
//            importHandler(nil, .none)
//        }
//    }
//
//    func documentBrowser(_ controller: UIDocumentBrowserViewController, didImportDocumentAt sourceURL: URL, toDestinationURL destinationURL: URL) {
//        // Present the MarkdownDocument View Controller for the new newly created document
//        presentDocument(at: destinationURL)
//    }
//
//    func documentBrowser(_ controller: UIDocumentBrowserViewController, failedToImportDocumentAt documentURL: URL, error: Error?) {
//        // Make sure to handle the failed import appropriately, e.g., by presenting an error message to the user.
//    }
}
