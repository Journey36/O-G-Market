//
//  ProductListRead.swift
//  O-G-Market
//
//  Created by 재현 on 2022/01/10.
//

import Foundation

struct ProductListRead: Encodable {
    let pageNumber: Int
    let itemsPerPage: Int

    enum CodingKeys: String, CodingKey {
        case pageNumber = "page_number"
        case itemsPerPage = "items_per_page"
    }
}
