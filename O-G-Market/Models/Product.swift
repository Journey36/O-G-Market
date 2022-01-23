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
    let price: Int
    let currency: Currency
    let discountedPrice: Int?
    let stock: Int?
    let secret: String


    enum CodingKeys: String, CodingKey {
        case name, descriptions, price, currency, stock, secret
        case discountedPrice = "discounted_price"
    }
}
