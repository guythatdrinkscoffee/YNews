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
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Life Cycle
    init(api: HNewsAPI = HNewsAPI()) {
        self.api = api
    }

    public func fetchStories(at endpoint: YNStoryEndpoint) -> AnyPublisher<[YNItem], Error> {
        guard let url = endpoint.url else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [Int].self, decoder: JSONDecoder())
            .flatMap { ids in
                return self.api.fetchItems(ids: Array(ids.prefix(50)))
            }
            .eraseToAnyPublisher()
    }
}
