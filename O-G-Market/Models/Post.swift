//
//  PostingInfo.swift
//  O-G-Market
//
//  Created by 재현 on 2022/01/09.
//

import Foundation

struct Post: Decodable, Hashable {
    let id: Int
    let vendorID: Int
    let name: String
    let description: String
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
        case id, name, description, thumbnail, currency, price, stock, images
        case vendorID = "vendor_id"
        case bargainPrice = "bargain_price"
        case discountedPrice = "discounted_price"
        case createdAt = "created_at"
        case issuedAt = "issued_at"
    }
}

extension Post {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        vendorID = try values.decode(Int.self, forKey: .vendorID)
        name = try values.decode(String.self, forKey: .name)
        description = try values.decodeIfPresent(String.self, forKey: .description) ?? String()
        thumbnail = try values.decode(String.self, forKey: .thumbnail)
        currency = try values.decode(Currency.self, forKey: .currency)
        price = try values.decode(Double.self, forKey: .price)
        bargainPrice = try values.decode(Double.self, forKey: .bargainPrice)
        discountedPrice = try values.decode(Double.self, forKey: .discountedPrice)
        images = try values.decodeIfPresent([Image].self, forKey: .images) ?? []
        stock = try values.decode(Int.self, forKey: .stock)
        createdAt = try values.decode(String.self, forKey: .createdAt)
        issuedAt = try values.decode(String.self, forKey: .issuedAt)
    }
}
