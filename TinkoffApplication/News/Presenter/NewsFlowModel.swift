//
//  NewsFlowModel.swift
//  TinkoffApplication
//
//  Created by Дмитрий Пермяков on 22.07.2023.
//  Copyright © 2021 Wildberries LLC. All rights reserved.
//

import Foundation

/// A memory storage holding immediately required or previously fetched data and view state.
struct NewsFlowModel {
    var appleNews: [ArticleFlowModel] = []
}

struct ArticleFlowModel {
    let id          = UUID()
    let title       : String?
    let description : String?
    let url         : URL?
    let urlToImage  : URL?
    let publishedAt : String?
    let source      : Source
}

