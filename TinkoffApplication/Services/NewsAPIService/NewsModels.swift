//
//  NewsModels.swift
//  TinkoffApplication
//
//  Created by Дмитрий Пермяков on 22.07.2023.
//

import Foundation

struct News: Decodable {
    let totalResults : Int
    let articles     : [Articles]
}

struct Articles: Decodable {
    let title       : String?
    let description : String?
    let url         : String?
    let urlToImage  : String?
    let publishedAt : String?
    let source      : Source
}

struct Source: Decodable {
    let id   : String?
    let name : String?
}
