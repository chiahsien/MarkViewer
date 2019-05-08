//
//  MarkdownDocumentBrowserTransitioningDelegate.swift
//  Mark Viewer
//
//  Created by Nelson Dai on 2019/5/8.
//  Copyright © 2019 Nelson Tai. All rights reserved.
//

import UIKit

class MarkdownDocumentBrowserTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    let transitionController: UIDocumentBrowserTransitionController

    init(withTransitionController transitionController: UIDocumentBrowserTransitionController) {
        self.transitionController = transitionController
    }

    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transitionController
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transitionController
    }
}
