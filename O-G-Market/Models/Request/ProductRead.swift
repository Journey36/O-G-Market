//
//  ProductRead.swift
//  O-G-Market
//
//  Created by 재현 on 2022/01/09.
//

import Foundation

struct ProductRead: Encodable {
    let productID: Int

    enum CodingKeys: String, CodingKey {
        case productID = "product_id"
    }
}
