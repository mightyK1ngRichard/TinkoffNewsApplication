//
//  NewsCellModel.swift
//  TinkoffApplication
//
//  Created by Дмитрий Пермяков on 22.07.2023.
//

import Foundation

struct NewsCellModel {
    var id          : UUID
    var title       : String?
    var image       : URL?
    var viewCounter : Int
}
