//
//  Date+.swift
//  O-G-Market
//
//  Created by Params on 2022/06/13.
//

import Foundation

extension Date {
    var relativeDateFormatting: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let dateString = dateFormatter.string(from: self)
        guard let date = dateFormatter.date(from: dateString) else {
            return ""
        }

        let relativeDateFormatter = DateFormatter()
        relativeDateFormatter.doesRelativeDateFormatting = true
        relativeDateFormatter.dateStyle = .medium
        return relativeDateFormatter.string(from: date)
    }
}
