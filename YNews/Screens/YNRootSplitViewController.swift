//
//  YNRootSplitViewController.swift
//  YNews
//
//  Created by J Manuel Zaragoza on 2/14/23.
//

import UIKit

class YNRootSplitViewController: UISplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // configuration
        configureViewController()
    }
}

// MARK: - Configuration
extension YNRootSplitViewController {
    private func configureViewController() {
        view.backgroundColor = .systemBackground
    }
}
