//
//  YNStoryEndpoints.swift
//  YNews
//
//  Created by J Manuel Zaragoza on 2/11/23.
//

import Foundation

public enum YNStoryEndpoint {
    static let baseUrl = URL(string: "https://hacker-news.firebaseio.com/v0")
    case new
    case top
    case best
    
    var url: URL? {
        switch self {
        case .new:
            return YNStoryEndpoint.baseUrl?.appendingPathComponent("newstories.json")
        case .top:
            return YNStoryEndpoint.baseUrl?.appendingPathComponent("topstories.json")
        case .best:
            return YNStoryEndpoint.baseUrl?.appendingPathComponent("beststories.json")
        }
    }
    
    var name: String {
        switch self {
        case .new:
            return "New"
        case .top:
            return "Top"
        case .best:
            return "Best"
        }
    }
}
