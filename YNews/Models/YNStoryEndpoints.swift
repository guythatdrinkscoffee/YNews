//
//  YNStoryEndpoints.swift
//  YNews
//
//  Created by J Manuel Zaragoza on 2/11/23.
//

import Foundation
import UIKit

public enum YNStoryEndpoint: Int, CaseIterable {
    static let baseUrl = URL(string: "https://hacker-news.firebaseio.com/v0")
    
    case top
    case best
    case ask
    case show
    case job
    case new
    
    var url: URL? {
        switch self {
        case .new:
            return YNStoryEndpoint.baseUrl?.appendingPathComponent("newstories.json")
        case .top:
            return YNStoryEndpoint.baseUrl?.appendingPathComponent("topstories.json")
        case .best:
            return YNStoryEndpoint.baseUrl?.appendingPathComponent("beststories.json")
        case .ask:
            return YNStoryEndpoint.baseUrl?.appendingPathComponent("askstories.json")
        case .job:
            return YNStoryEndpoint.baseUrl?.appendingPathComponent("jobstories.json")
        case .show:
            return YNStoryEndpoint.baseUrl?.appendingPathComponent("showstories.json")
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
        case .ask:
            return "Ask"
        case .show:
            return "Show"
        case .job:
            return "Jobs"
        }
    }
    
    var image: UIImage? {
        switch self {
        case .new:
            return UIImage(systemName: "wand.and.stars")
        case .top:
            return UIImage(systemName: "chart.line.uptrend.xyaxis")
        case .best:
            return UIImage(systemName: "star.fill")
        case .ask:
            return UIImage(systemName: "mic.fill")
        case .show:
            return UIImage(systemName: "macwindow")
        case .job:
            return UIImage(systemName: "doc.on.clipboard.fill")
        }
    }
    
    var max: Int {
        switch self {
        case .top, .best, .new: return 500
        case .ask, .show, .job: return 200
        }
    }
}
