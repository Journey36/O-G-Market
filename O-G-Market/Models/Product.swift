//
//  Product.swift
//  O-G-Market
//
//  Created by 재현 on 2022/01/03.
//

import Foundation

struct Product: Encodable {
    let name: String
    let descriptions: String
    let price: Double
    let currency: Currency
    let discountedPrice: Double?
    let stock: Int?
    let secret: String


    enum CodingKeys: String, CodingKey {
        case name, descriptions, price, currency, stock, secret
        case discountedPrice = "discounted_price"
    }
}
