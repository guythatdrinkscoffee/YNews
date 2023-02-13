//
//  Item.swift
//  YNews
//
//  Created by J Manuel Zaragoza on 2/9/23.
//

import UIKit

struct YNItem: Codable {
    let id: Int
    let type: String? // Type of item "job", "poll", "comment", "poll"
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
        
        return ""
    }
    
    var relativeTime: String {
        let date = Date(timeIntervalSince1970: timeStamp)
        return date.formatted(.relative(presentation: .numeric, unitsStyle: .abbreviated))
    }
    
    var link: URL? {
        if let urlString = url {
            return URL(string: urlString)
        }
        
        return nil
    }
    
    func  getAttributedText(font: UIFont = .preferredFont(forTextStyle: .body)) -> NSAttributedString? {
        if let text = text, let textData = text.data(using: .utf16) {
            let attributedText = try? NSMutableAttributedString(
                data: textData,
                options: [.documentType: NSAttributedString.DocumentType.html],
                documentAttributes: nil)
            attributedText?.addAttributes([.font: font], range: NSRange(location: 0, length: attributedText?.string.count ?? 0))
            return attributedText
        }
        
        return nil
    }
}

extension YNItem {
    static var placeholder: YNItem {
        guard let fileUrl = Bundle.main.url(forResource: "mock", withExtension: "json") else {
            return YNItem(id: 0, type: nil, author: nil, timeStamp: 0, text: nil, parent: nil, kids: nil, url: nil, score: nil, title: nil, descendents: nil)
        }
    
        do {
            let data = try Data(contentsOf: fileUrl)
            let item = try JSONDecoder().decode(YNItem.self, from: data)
            return item
        } catch {
            print(error.localizedDescription)
        }
        
        return YNItem(id: 0, type: nil, author: nil, timeStamp: 0, text: nil, parent: nil, kids: nil, url: nil, score: nil, title: nil, descendents: nil)
    }
}
