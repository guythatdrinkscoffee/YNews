//
//  ViewController.swift
//  YNews
//
//  Created by J Manuel Zaragoza on 2/9/23.
//

import UIKit

class YNRootTabScreen: UITabBarController {

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // configuration
        configureViewController()
    }
}

// MARK: - Configuration
extension YNRootTabScreen {
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        viewControllers = [
            makePostsScreen(),
            makeShowcaseScreen()
        ]
    }
    
    private func makePostsScreen() -> UINavigationController {
        let postsScreen = YNStoriesScreen()
        postsScreen.tabBarItem = UITabBarItem(title: "Stories", image: UIImage(systemName: "newspaper"), tag: 0)
        let containerNav = UINavigationController(rootViewController: postsScreen)
        return containerNav
    }
    
    private func makeShowcaseScreen() -> UINavigationController {
        let showcaseScreen = YNShowcaseScreen()
        showcaseScreen.tabBarItem = UITabBarItem(title: "Showcase", image: UIImage(systemName: "wand.and.rays"), tag: 1)
        let containerNav = UINavigationController(rootViewController: showcaseScreen)
        return containerNav
    }
}

