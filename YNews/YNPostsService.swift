//
//  YNPostsService.swift
//  YNews
//
//  Created by J Manuel Zaragoza on 2/9/23.
//

import Foundation
import Combine

final class YNPostsService {
    // MARK: - Private Properities
    private var api: HNewsAPI

    // MARK: - Life Cycle
    init(api: HNewsAPI = HNewsAPI()) {
        self.api = api
    }
    
    public func newStories() -> AnyPublisher<[YNItem], Error> {
        return api.fetchNewStories()
    }
}
