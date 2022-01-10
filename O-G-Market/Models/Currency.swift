//
//  Currency.swift
//  O-G-Market
//
//  Created by 재현 on 2022/01/08.
//

import Foundation

enum Currency: String, Codable {
    case KRW
    case USD
    case unknown

    init(from decoder: Decoder) throws {
        self = try Currency(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
    }
}
