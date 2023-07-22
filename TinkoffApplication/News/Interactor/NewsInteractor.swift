//
//  NewsInteractor.swift
//  TinkoffApplication
//
//  Created by Дмитрий Пермяков on 22.07.2023.
//  Copyright © 2021 Wildberries LLC. All rights reserved.
//

import Foundation

/// Facade for data providing services and workers.
final class NewsInteractor {

    // MARK: Init

    init() {}
    
}

// MARK: - NewsInteractorInput

extension NewsInteractor: NewsInteractorInput {
    func fetchData(from dateFrom: String? = nil, to dateTo: String? = nil, completion: @escaping (Result<News, Error>) -> Void) {
        NewsService.shared.getAppleNews(from: dateFrom, to: dateTo, completion: completion)
    }
    
    func fetchData(from dateFrom: String? = nil, to dateTo: String? = nil) async throws -> News {
        return try await NewsService.shared.getAppleNews()
    }
    
}
