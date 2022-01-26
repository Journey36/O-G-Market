//
//  ProductCreation.swift
//  O-G-Market
//
//  Created by 재현 on 2022/01/09.
//

import Foundation

struct ProductCreation: Encodable {
    let identifier: String // header에 쏴주는데 필요한가?
    let product: Product
    let images: Data

    enum CodingKeys: String, CodingKey {
        case identifier, images
        case product = "params"
    }
}
