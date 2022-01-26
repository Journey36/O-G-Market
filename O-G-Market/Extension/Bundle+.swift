//
//  Bundle+.swift
//  O-G-Market
//
//  Created by 재현 on 2022/01/24.
//

import Foundation

extension Bundle {
    var identifier: String {
        guard let file = Self.main.url(forResource: "Info", withExtension: "plist") else {
            return "Cannot find Info.plist file."
        }

        do {
            let resource = try NSDictionary(contentsOf: file, error: ())
            guard let key = resource["IDENTIFIER"] as? String else {
                return "Cannot find key, \"IDENTIFIER\" at Info.plist file."
            }

            return key
        } catch {
            return error.localizedDescription
        }
    }

    var password: String {
        guard let file = Self.main.url(forResource: "Info", withExtension: "plist") else {
            return "Cannot find Info.plist file."
        }

        do {
            let resource = try NSDictionary(contentsOf: file, error: ())
            guard let key = resource["PASSWORD"] as? String else {
                return "Cannot find key, \"PASSWORD\" at Info.plist file."
            }

            return key
        } catch {
            return error.localizedDescription
        }
    }
}
