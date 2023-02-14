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
    private var currentPage = 1
    private var storyCount = 50
    private var currentEnpointType: YNStoryEndpoint = .top
    public var isFetching = false
    public var exhausted = false
    
    // MARK: - Life Cycle
    init(api: HNewsAPI = HNewsAPI()) {
        self.api = api
    }

    public func fetchStories(at endpoint: YNStoryEndpoint) -> AnyPublisher<[YNItem], Error> {
        guard let url = endpoint.url else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        if currentEnpointType != endpoint {
            self.currentEnpointType = endpoint
            self.currentPage = 1
            self.exhausted = false
        }
        
        self.isFetching = true
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [Int].self, decoder: JSONDecoder())
            .flatMap { (ids: [Int]) in
                let offset = (self.currentPage - 1) * self.storyCount
                
                var remainingIds: [Int] = []
    
                for i in stride(from: offset, to: self.storyCount * self.currentPage, by: 1) {
                    if i >= ids.count {
                        self.exhausted = true
                        break
                    }
            
                    remainingIds.append(ids[i])
                }
            
                return self.api.fetchItems(ids: remainingIds)
            }
            .handleEvents(receiveCompletion: { completion in
                self.currentPage += 1
                self.isFetching = false
            })
            .eraseToAnyPublisher()
    }
}
