//
//  Data+.swift
//  O-G-Market
//
//  Created by 재현 on 2022/01/21.
//

import Foundation

extension Data {
        /// Convert string to data using `utf8`.
        /// - Parameter string: A string that you want to change `utf8` data type.
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}
