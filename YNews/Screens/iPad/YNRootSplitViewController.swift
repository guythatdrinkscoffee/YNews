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
        viewControllers = [ makePrimaryViewController(), makeSecondaryViewController(), makeDetailViewController()]
    }
    
    private func makePrimaryViewController() -> UIViewController {
        let selectionSections: [YNSelectionSection] = [
            .init(children: YNStoryEndpoint.allCases),
            .init(children: [YNBookmarksEndpoint.bookmarks])
        ]
        
        return YNPrimaryViewController(sections: selectionSections, style: .insetGrouped)
    }
    
    private func makeSecondaryViewController() -> UIViewController {
        return YNSecondaryViewController()
    }
    
    private func makeDetailViewController() -> UIViewController {
        return YNStoryDetailScreen(story: .placeholder)
    }
}
