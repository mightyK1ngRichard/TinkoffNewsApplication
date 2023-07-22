//
//  NewsPresenter.swift
//  TinkoffApplication
//
//  Created by Дмитрий Пермяков on 22.07.2023.
//  Copyright © 2021 Wildberries LLC. All rights reserved.
//

import Foundation

final class NewsPresenter {
    
    // MARK: Dependencies
    
    private let interactor: NewsInteractorInput
    private let router: NewsRouterInput
    weak var view: NewsViewControllerInput?
    
    // MARK: Properties
    
    private var model: NewsFlowModel
    
    // MARK: Init
    
    init(
        interactor: NewsInteractorInput,
        router: NewsRouterInput,
        model: NewsFlowModel
    ) {
        self.interactor = interactor
        self.router = router
        self.model = model
    }
    
}

// MARK: - NewsPresenterInput

extension NewsPresenter: NewsPresenterInput {
    func viewDidFinishLaunching() {
        /* Два возможных способа */
        //fetchData()
        fetchDataAsync()
    }
    
    func userDidSelectNews(cellID: UUID) {
        let pressedArticle = model.appleNews.first { $0.id == cellID }
        guard let pressedArticle = pressedArticle else {
            // TODO: Сделать alert.
            return
        }
        let data = NewsDetailModel(
            title: pressedArticle.title,
            description: pressedArticle.description,
            url: pressedArticle.url,
            urlToImage: pressedArticle.urlToImage,
            publishedAt: pressedArticle.publishedAt,
            sourceName: pressedArticle.source.name
        )
        router.showNewsDetailView(with: data, presenter: self)
    }
}

// MARK: - Private func's of NewsPresenter.

private extension NewsPresenter {
    func fetchDataAsync() {
        Task {
            do {
                let articles = try await interactor.fetchData(from: nil, to: nil).articles
                self.model.appleNews = articles.map { ArticleFlowModel(
                    title: $0.title,
                    description: $0.description,
                    url: $0.url == nil ? nil :  URL(string: $0.url!),
                    urlToImage: $0.urlToImage == nil ? nil : URL(string: $0.urlToImage!),
                    publishedAt: $0.publishedAt,
                    source: $0.source)
                }
                guard let view = view else { return }
                DispatchQueue.main.async {
                    view.configure(NewsViewModel(newsCell: self.model.appleNews.map {
                        NewsCellModel(
                            id: $0.id,
                            title: $0.title,
                            image: $0.urlToImage,
                            viewCounter: 0)
                    }))
                }
                
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchData() {
        guard let view = view else { return }
        interactor.fetchData(from: nil, to: nil, completion: { result in
            switch result {
            case .success(let news):
                self.model.appleNews = news.articles.map { ArticleFlowModel(
                    title: $0.title,
                    description: $0.description,
                    url: $0.url == nil ? nil :  URL(string: $0.url!),
                    urlToImage: $0.urlToImage == nil ? nil : URL(string: $0.urlToImage!),
                    publishedAt: $0.publishedAt,
                    source: $0.source)
                }
                let newsForCell = self.model.appleNews.map {
                    NewsCellModel(
                        id: $0.id,
                        title: $0.title,
                        image: $0.urlToImage,
                        viewCounter: 0)
                }
                view.configure(NewsViewModel(newsCell: newsForCell))
                
            case .failure(let error):
                print(error)
            }
        })
    }
    
    
}
