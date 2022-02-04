//
//  ListItem.swift
//  O-G-Market
//
//  Created by 재현 on 2022/02/03.
//

import Foundation

struct ListItem: Decodable, Hashable {

    let id: Int
    let vendorID: Int
    let name: String
    let thumbnail: String
    let currency: Currency
    let price: Double
    let bargainPrice: Double
    let discountedPrice: Double
    let stock: Int
    let createdAt: String
    let issuedAt: String

    enum CodingKeys: String, CodingKey {
        case id, name, thumbnail, currency, price, stock
        case vendorID = "vendor_id"
        case bargainPrice = "bargain_price"
        case discountedPrice = "discounted_price"
        case createdAt = "created_at"
        case issuedAt = "issued_at"
    }
}
