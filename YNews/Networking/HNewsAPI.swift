//
//  HNewsAPI.swift
//  YNews
//
//  Created by J Manuel Zaragoza on 2/9/23.
//

import Foundation
import Combine

struct HNewsAPI {
    private enum ItemEndpoint {
        static let baseUrl = URL(string: "https://hacker-news.firebaseio.com/v0")
        case item(Int)
        var url: URL? {
            switch self {
            case .item(let id): return ItemEndpoint.baseUrl?.appending(path: "/item/\(id).json")
            }
        }
    }
    
    private func fetchItem(at endPoint: ItemEndpoint) -> AnyPublisher<YNItem, Error> {
        guard let itemUrl = endPoint.url else {
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
        let initialPublisher = fetchItem(at: .item(initialId))
        
        return remainingIds.reduce(initialPublisher) { partialResult, nextId in
            partialResult
                .merge(with: fetchItem(at: .item(nextId)))
                .eraseToAnyPublisher()
        }
    }
}

// MARK: - Public Methods
extension HNewsAPI {
    public func fetchItems(ids: [Int]) -> AnyPublisher<[YNItem], Error> {
        return mergeItems(ids: ids)
            .collect()
            .eraseToAnyPublisher()
    }
}


