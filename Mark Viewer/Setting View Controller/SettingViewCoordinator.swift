//
//  SettingViewCoordinator.swift
//  Mark Viewer
//
//  Created by Nelson Dai on 2019/5/20.
//  Copyright © 2019 Nelson Tai. All rights reserved.
//

import UIKit

protocol SettingViewCoordinatorDelegate: AnyObject {
    func coordinatorDidFinish(_ coordinator: SettingViewCoordinator)
    func coordinatorDidCancel(_ coordinator: SettingViewCoordinator)
}

final class SettingViewCoordinator: UIViewController {
    private var nav: UINavigationController!
    private var syntaxVC: SyntaxHighlightViewController!

    weak var delegate: SettingViewCoordinatorDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        syntaxVC = SyntaxHighlightViewController()
        nav = UINavigationController(rootViewController: syntaxVC)
        addChild(nav)
        view.addSubview(nav.view)
        nav.didMove(toParent: self)

        setupNavigationItems()
    }
}

private extension SettingViewCoordinator {
    func setupNavigationItems() {
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        syntaxVC.navigationItem.leftBarButtonItem = cancelItem

        let saveItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveSetting))
        syntaxVC.navigationItem.rightBarButtonItem = saveItem
    }

    @objc
    func saveSetting() {
        syntaxVC.saveSetting()
        delegate?.coordinatorDidFinish(self)
    }

    @objc
    func cancel() {
        delegate?.coordinatorDidCancel(self)
    }
}
