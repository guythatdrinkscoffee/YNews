//
//  ShowcaseScreen.swift
//  YNews
//
//  Created by J Manuel Zaragoza on 2/9/23.
//

import UIKit

class YNShowcaseScreen: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // configuration
        configureViewController()
    }
}

// MARK: - Configuration
extension YNShowcaseScreen {
    private func configureViewController() {
        view.backgroundColor = .systemBackground
    }
}
