//
//  ProductCreation.swift
//  O-G-Market
//
//  Created by 재현 on 2022/01/09.
//

import Foundation

struct ProductCreation: Encodable {
    let product: Product
    let images: [Data]

    enum CodingKeys: String, CodingKey {
        case images
        case product = "params"
    }
}
