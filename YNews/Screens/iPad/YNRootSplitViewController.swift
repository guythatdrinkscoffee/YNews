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
        
        let controller = YNPrimaryViewController(sections: selectionSections, style: .insetGrouped)
      
        return controller
    }
    
    private func makeSecondaryViewController() -> UIViewController {
        let controller = YNSecondaryViewController()
        controller.delegate = self
        return controller
    }
    
    private func makeDetailViewController() -> UIViewController {
        return YNStoryDetailScreen(story: .placeholder)
    }
}

// MARK: - YNSelectionDelegate
extension YNRootSplitViewController: YNSelectionDelegate {
    func controller(didSelect item: YNItem) {
        if let lastViewController = viewControllers.last as? UINavigationController,
            let detailView = lastViewController.viewControllers.first as? YNStoryDetailScreen {
            detailView.setItem(item: item)
        }
    }
    
    
}
