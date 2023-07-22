//
//  NewsRouter.swift
//  TinkoffApplication
//
//  Created by Дмитрий Пермяков on 22.07.2023.
//  Copyright © 2021 Wildberries LLC. All rights reserved.
//

import UIKit

internal final class NewsRouter {
    
    weak var viewController: UIViewController?
    
}

extension NewsRouter: NewsRouterInput {
    func showNewsDetailView(with data: NewsDetailModel, presenter: NewsPresenterInput) {
        let vc = NewsDetailViewController(data, presenter: presenter)
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
