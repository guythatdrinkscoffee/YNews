//
//  ShowcaseScreen.swift
//  YNews
//
//  Created by J Manuel Zaragoza on 2/9/23.
//

import UIKit

class ShowcaseScreen: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // configuration
        configureViewController()
    }
}

// MARK: - Configuration
extension ShowcaseScreen {
    private func configureViewController() {
        view.backgroundColor = .systemBackground
    }
}
