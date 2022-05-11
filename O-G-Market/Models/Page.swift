//
//  ProductList.swift
//  O-G-Market
//
//  Created by 재현 on 2022/01/10.
//

import Foundation

struct Page: Decodable, Hashable {
    let number: Int
    let postPerPage: Int
    let postCount: Int
    let firstIndex: Int
    let lastIndex: Int
    let lastPage: Int
    let hasNextPage: Bool
    let hasPreviousPage: Bool
    let post: [Post]

    enum CodingKeys: String, CodingKey {
        case number = "page_no"
        case postPerPage = "items_per_page"
        case postCount = "total_count"
        case firstIndex = "offset"
        case lastIndex = "limit"
        case lastPage = "last_page"
        case hasNextPage = "has_next"
        case hasPreviousPage = "has_prev"
        case post = "pages"
    }
}
