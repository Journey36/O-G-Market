//
//  ProductUpdate.swift
//  O-G-Market
//
//  Created by 재현 on 2022/01/09.
//

import Foundation

struct Update: Encodable {
    let name: String?
    let descriptions: String?
    let thumbnailID: Int?
    let price: Double?
    let currency: Currency?
    let discountedPrice: Double?
    let stock: Int?
    let secret: String

    enum CodingKeys: String, CodingKey {
        case name, descriptions, price, currency, stock, secret
        case thumbnailID = "thumbnail_id"
        case discountedPrice = "discounted_price"
    }
}
