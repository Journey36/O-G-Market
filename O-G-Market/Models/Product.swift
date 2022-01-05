//
//  Product.swift
//  O-G-Market
//
//  Created by 재현 on 2022/01/03.
//

import Foundation

struct Product: Codable {
    let name: String
    let descriptions: String
    let price: UInt
    let currency: Currency
    var discountedPrice: UInt = 0
    var stock: UInt = 0

    enum CodingKeys: String, CodingKey {
        case name, descriptions, currency, stock
        case price = "amount"
        case discountedPrice = "discounted_price"
    }
}

enum Currency: String, Codable {
    case KRW
    case USD
    case unknown

    init(from decoder: Decoder) throws {
        self = try Currency(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
    }
}
