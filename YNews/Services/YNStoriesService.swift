//
//  YNPostsService.swift
//  YNews
//
//  Created by J Manuel Zaragoza on 2/9/23.
//

import Foundation
import Combine

final class YNStoriesService {
    // MARK: - Private Properities
    private var api: HNewsAPI
    
    private enum StoryEndpoints {
        static let baseUrl = URL(string: "https://hacker-news.firebaseio.com/v0")
        case new
        case top
        case best
        
        var url: URL? {
            switch self {
            case .new:
                return StoryEndpoints.baseUrl?.appendingPathComponent("newstories.json")
            case .top:
                return StoryEndpoints.baseUrl?.appendingPathComponent("topstories.json")
            case .best:
                return StoryEndpoints.baseUrl?.appendingPathComponent("beststories.json")
            }
        }
    }
    
    // MARK: - Life Cycle
    init(api: HNewsAPI = HNewsAPI()) {
        self.api = api
    }

    public func fetchNewStories() -> AnyPublisher<[YNItem], Error> {
        guard let url = StoryEndpoints.new.url else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [Int].self, decoder: JSONDecoder())
            .flatMap { newStoryIds in
                return self.api.fetchItems(ids: Array(newStoryIds.prefix(25)))
            }
            .eraseToAnyPublisher()
    }
    
    public func fetchTopStories() -> AnyPublisher<[YNItem], Error> {
        guard let url = StoryEndpoints.top.url else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [Int].self, decoder: JSONDecoder())
            .flatMap { newStoryIds in
                return self.api.fetchItems(ids: Array(newStoryIds.prefix(25)))
            }
            .eraseToAnyPublisher()
    }
    
    public func fetchBestStories() -> AnyPublisher<[YNItem], Error> {
        guard let url = StoryEndpoints.best.url else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [Int].self, decoder: JSONDecoder())
            .flatMap { newStoryIds in
                return self.api.fetchItems(ids: Array(newStoryIds.prefix(25)))
            }
            .eraseToAnyPublisher()
    }
}
