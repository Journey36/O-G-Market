//
//  ProductDeletion.swift
//  O-G-Market
//
//  Created by 재현 on 2022/01/09.
//

import Foundation

struct ProductDeletion: Encodable {
    let identifier: String
    let productID: Int
    let productSecret: String

    enum CodingKeys: String, CodingKey {
        case identifier
        case productID = "product_id"
        case productSecret = "product_secret"
    }
}
