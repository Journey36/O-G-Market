//
//  PostingInfo.swift
//  O-G-Market
//
//  Created by 재현 on 2022/01/09.
//

import Foundation

struct Post: Decodable, Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(images)
    }

    static func == (lhs: Post, rhs: Post) -> Bool {
        return lhs.images == rhs.images
    }

    let id: Int
    let vendorID: Int
    let name: String
    let thumbnail: String
    let currency: Currency
    let price: Double
    let bargainPrice: Double
    let discountedPrice: Double
    let images: [Image]
    let stock: Int
    let createdAt: String
    let issuedAt: String

    enum CodingKeys: String, CodingKey {
        case id, name, thumbnail, currency, price, stock, images
        case vendorID = "vendor_id"
        case bargainPrice = "bargain_price"
        case discountedPrice = "discounted_price"
        case createdAt = "created_at"
        case issuedAt = "issued_at"
    }
}
