//
//  NewsComposer.swift
//  TinkoffApplication
//
//  Created by Дмитрий Пермяков on 22.07.2023.
//  Copyright © 2021 Wildberries LLC. All rights reserved.
//

import UIKit

public struct NewsModuleInputContainer {
    
}

public enum NewsComposer {

    /// Creates new News module.
    public static func make() -> UIViewController {
        let interactor = NewsInteractor()
        let router = NewsRouter()
        let model = NewsFlowModel()
        let presenter = NewsPresenter(
            interactor: interactor,
            router: router,
            model: model
        )
        let viewController = NewsViewController(presenter: presenter)
        router.viewController = viewController
        presenter.view = viewController
        return viewController
    }

}

private extension NewsModuleInputContainer {

    /// Mock input instance for tests and debug.
    static let mock = NewsModuleInputContainer(
       // Add mock parameters.
    )
}
