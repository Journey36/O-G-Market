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
    let discountedPrice: UInt? = 0
    let stock: UInt? = 0
    let secret: String


    enum CodingKeys: String, CodingKey {
        case name, descriptions, price, currency, stock, secret
        case discountedPrice = "discounted_price"
    }
}
