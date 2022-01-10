//
//  ProductUpdate.swift
//  O-G-Market
//
//  Created by 재현 on 2022/01/09.
//

import Foundation

struct ProductUpdate: Encodable {
    let identifier: String
    let productID: Int
    let name: String?
    let descriptions: String?
    let thumbnailID: Int?
    let price: UInt?
    let currency: Currency?
    let discountedPrice: Int? = 0
    let stock: Int? = 0
    let secret: String

    enum CodingKeys: String, CodingKey {
        case identifier, name, descriptions, price, currency, stock, secret
        case productID = "product_id"
        case thumbnailID = "thumbnail_id"
        case discountedPrice = "discounted_price"
    }
}
