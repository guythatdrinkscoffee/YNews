//
//  ViewController.swift
//  YNews
//
//  Created by J Manuel Zaragoza on 2/9/23.
//

import UIKit

class RootTabScreen: UITabBarController {

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // configuration
        configureViewController()
    }
}

// MARK: - Configuration
extension RootTabScreen {
    private func configureViewController() {
        view.backgroundColor = .systemBackground
    }
}

