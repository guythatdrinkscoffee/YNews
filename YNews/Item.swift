//
//  Item.swift
//  YNews
//
//  Created by J Manuel Zaragoza on 2/9/23.
//

import Foundation


struct Item: Codable {
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
