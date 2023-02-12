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
            makeBookmarksScreen()
        ]
    }
    
    private func makePostsScreen() -> UINavigationController {
        let postsScreen = YNStoriesScreen()
        postsScreen.tabBarItem = UITabBarItem(title: "Stories", image: UIImage(systemName: "newspaper"), tag: 0)
        let containerNav = UINavigationController(rootViewController: postsScreen)
        return containerNav
    }
    
    private func makeBookmarksScreen() -> UINavigationController {
        let bookmarksScreen = YNBookmarksScreen()
        bookmarksScreen.tabBarItem = UITabBarItem(title: "Bookmarks", image: UIImage(systemName: "bookmark"), tag: 1)
        let containerNav = UINavigationController(rootViewController: bookmarksScreen)
        return containerNav
    }
}

