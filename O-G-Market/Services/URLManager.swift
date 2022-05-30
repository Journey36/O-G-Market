//
//  URLManager.swift
//  O-G-Market
//
//  Created by 재현 on 2022/01/10.
//

import Foundation
import Alamofire

struct URLManager {
    private let apiAddress = "https://market-training.yagom-academy.kr/api/products"

    func makeRegistrationURL() throws -> URL {
        guard let endpoint = try? apiAddress.asURL() else {
            throw AFError.invalidURL(url: apiAddress)
        }

        return endpoint
    }

    func makePageInquiryURL(startPage: Int) throws -> URL {
        guard var components = URLComponents(string: apiAddress) else {
            throw AFError.invalidURL(url: apiAddress)
        }

        let startPage = URLQueryItem(name: "page_no", value: "\(startPage)")
        let postPerPage = URLQueryItem(name: "items_per_page", value: "20")
        components.queryItems = [startPage, postPerPage]

        guard let endpoint = try? components.asURL() else {
            throw AFError.invalidURL(url: apiAddress)
        }

        return endpoint
    }

    func makeProductInquiryURL(productID: Int) throws -> URL {
        guard let endpoint = try? apiAddress.asURL().appendingPathComponent("\(productID)") else {
            throw AFError.invalidURL(url: apiAddress)
        }

        return endpoint
    }

    func makeProductUpdateURL(productID: Int) throws -> URL {
        guard let endpoint = try? apiAddress.asURL().appendingPathComponent("\(productID)") else {
            throw AFError.invalidURL(url: apiAddress)
        }

        return endpoint
    }

    func makeProductSecretInquiryURL(productID: Int) throws -> URL {
        guard let endpoint = try? apiAddress.asURL().appendingPathComponent("\(productID)")
            .appendingPathComponent("secret") else {
            throw AFError.invalidURL(url: apiAddress)
        }

        return endpoint
    }

    func makeProductDeletionURL(productID: Int, productSecret: String) throws -> URL {
        guard let endpoint = try? apiAddress.asURL().appendingPathComponent("\(productID)")
            .appendingPathComponent(productSecret) else {
            throw AFError.invalidURL(url: apiAddress)
        }

        return endpoint
    }
}
