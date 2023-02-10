//
//  Item.swift
//  YNews
//
//  Created by J Manuel Zaragoza on 2/9/23.
//

import Foundation


struct YNItem: Codable {
    let id: Int
    let type: String? // Type of item "post", "poll", "comment", "poll"
    let author: String? // Username of the user that posted the item
    let timeStamp: TimeInterval // UNIX Time
    let text: String? // HTML
    let parent: Int? // The comment's parent, another comment or the relevant story
    let kids: [Int]? // The ids of the item's comments, sorted by rank.
    let url: String?
    let score: Int?
    let title: String? // Title of story, poll or job. HTML
    let descendents: Int? // Total comment count for stories or polls
    
    enum CodingKeys: String, CodingKey {
        case id, type
        case author = "by"
        case timeStamp = "time"
        case text, parent, kids, url, score, title, descendents
    }
}

extension YNItem {
    var host: String? {
        if let urlString = url, let components = URLComponents(string: urlString) {
            return components.host
        }
        
        return "n/a"
    }
    
    var relativeTime: String {
        let date = Date(timeIntervalSince1970: timeStamp)
        return date.formatted(.relative(presentation: .numeric, unitsStyle: .abbreviated))
    }
}
