//
//  ProductUpdate.swift
//  O-G-Market
//
//  Created by 재현 on 2022/01/09.
//

import Foundation

struct ProductUpdate: Encodable {
    let name: String?
    let descriptions: String?
    let thumbnailID: Int?
    let price: Int?
    let currency: Currency?
    let discountedPrice: Int?
    let stock: Int?
    let secret: String

    enum CodingKeys: String, CodingKey {
        case name, descriptions, price, currency, stock, secret
        case thumbnailID = "thumbnail_id"
        case discountedPrice = "discounted_price"
    }
}
