//
//  Image.swift
//  O-G-Market
//
//  Created by 재현 on 2022/01/08.
//

import Foundation

struct Image: Decodable, Hashable {
    let id: Int
    let url: String
    let thumbnailURL: String
    let isSucceed: Bool
    let issuedAt: String

    enum CodingKeys: String, CodingKey {
        case id, url
        case isSucceed = "succeed"
        case thumbnailURL = "thumbnail_url"
        case issuedAt = "issued_at"
    }
}
