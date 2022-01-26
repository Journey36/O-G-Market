//
//  ProductList.swift
//  O-G-Market
//
//  Created by 재현 on 2022/01/10.
//

import Foundation

struct ProductList: Decodable {
    let pageNumber: Int
    let itemsPerPage: Int
    let itemsCount: Int
    let firstIndex: Int
    let lastIndex: Int
    let lastPage: Int
    let hasNextPage: Bool
    let hasPreviousPage: Bool
    let pages: [PostingInfo]

    enum CodingKeys: String, CodingKey {
        case pageNumber = "page_no"
        case itemsPerPage = "items_per_page"
        case itemsCount = "total_count"
        case firstIndex = "offset"
        case lastIndex = "limit"
        case lastPage = "last_page"
        case hasNextPage = "has_next"
        case hasPreviousPage = "has_prev"
        case pages
    }
}
