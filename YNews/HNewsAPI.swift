//
//  HNewsAPI.swift
//  YNews
//
//  Created by J Manuel Zaragoza on 2/9/23.
//

import Foundation
import Combine

struct HNewsAPI {
    static let baseUrl = URL(string: "https://hacker-news.firebaseio.com/v0")
    
    private  enum Endpoints {
        case newStories
        case item(Int)
        var url: URL? {
            switch self {
            case .newStories: return HNewsAPI.baseUrl?.appendingPathComponent("/newstories.json")
            case .item(let id): return HNewsAPI.baseUrl?.appending(path: "/item/\(id).json")
            }
        }
    }
    
    private func fetchItem(id: Int) -> AnyPublisher<YNItem, Error> {
        guard let itemUrl = Endpoints.item(id).url else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: itemUrl)
            .map(\.data)
            .decode(type: YNItem.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    private func mergeItems(ids: [Int]) -> AnyPublisher<YNItem, Error> {
        let initialId = ids.first!
        let remainingIds = Array(ids.dropFirst())
        let initialPublisher = fetchItem(id: initialId)
        
        return remainingIds.reduce(initialPublisher) { partialResult, nextId in
            partialResult
                .merge(with: fetchItem(id: nextId))
                .eraseToAnyPublisher()
        }
    }
}

// MARK: - Public Methods
extension HNewsAPI {
    public func fetchNewStories() -> AnyPublisher<[YNItem], Error> {
        guard let newStoriesUrl = Endpoints.newStories.url else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: newStoriesUrl)
            .map(\.data)
            .decode(type: [Int].self, decoder: JSONDecoder())
            .flatMap({ ids in
                return mergeItems(ids: Array(ids.prefix(50)))
            })
            .collect()
            .eraseToAnyPublisher()
    }
}


