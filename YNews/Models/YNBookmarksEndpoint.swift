//
//  YNBookmarksEndpoint.swift
//  YNews
//
//  Created by J Manuel Zaragoza on 2/14/23.
//

import UIKit

enum YNBookmarksEndpoint: SelectionProtocol {
    case bookmarks
    
    var name: String {
        return "Bookmarked"
    }
    
    var image: UIImage? {
        return UIImage(systemName: "bookmark.fill")
    }
    
    var color: UIColor {
        return .systemOrange
    }
}
