//
//  PostingInfo.swift
//  O-G-Market
//
//  Created by 재현 on 2022/01/09.
//

import Foundation

struct PostingInfo: Decodable {
    let id: Int
    let venderID: Int
    let name: String
    let thumbnail: String
    let currency: Currency
    let price: UInt
    let bargainPrice: UInt
    let discountedPrice: Int
    let stock: Int
    let images: [Image]
    let createdAt: String
    let issuedAt: String

    enum CodingKeys: String, CodingKey {
        case id, name, thumbnail, currency, price, stock, images
        case venderID = "vender_id"
        case bargainPrice = "bargain_price"
        case discountedPrice = "discounted_price"
        case createdAt = "created_at"
        case issuedAt = "issued_at"
    }
}
