//
//  NewsContract.swift
//  TinkoffApplication
//
//  Created by Дмитрий Пермяков on 22.07.2023.
//  Copyright © 2021 Wildberries LLC. All rights reserved.
//

import Foundation

/// Interface of controller object which view delegates its events.
protocol NewsPresenterInput {
    func viewDidFinishLaunching()
    func userDidSelectNews(cellID: UUID)
}

/// View interface.
protocol NewsViewControllerInput: AnyObject {
    func configure(_ viewModel: NewsViewModel)
    func showErrorView(text: String) 
}

/// Interface of all data-related managing object. Network interaction, database fetching etc.
protocol NewsInteractorInput {
    /// Example fetching method. Replace `Data` with your specific model object type.
    func fetchData(from dateFrom: String?, to dateTo: String?) async throws -> News
    func fetchData(from dateFrom: String?, to dateTo: String?, completion: @escaping (Result<News, Error>) -> Void)
}

/// Interface of object handling all the navigation.
protocol NewsRouterInput {
    func showNewsDetailView(with data: NewsDetailModel, presenter: NewsPresenterInput)
}
