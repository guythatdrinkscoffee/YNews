//
//  YNCommentsService.swift
//  YNews
//
//  Created by J Manuel Zaragoza on 2/11/23.
//

import UIKit
import Combine


struct CommentResponse {
    var hasMoreReplies = true
    var commentIds: [Int] = []
}

final class YNCommentsService {
    // MARK: - Properties
    private var api: HNewsAPI
    
    // MARK: - Life Cycle
    init(api: HNewsAPI = HNewsAPI()) {
        self.api = api
    }
}

// MARK: - Public Methods
extension YNCommentsService {
    public func fetchRootComments(ids: [Int]) -> AnyPublisher<[YNItem], Error> {
        api.fetchItems(ids: ids)
            .eraseToAnyPublisher()
    }
}


