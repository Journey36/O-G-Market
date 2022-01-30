//
//  URLManager.swift
//  O-G-Market
//
//  Created by 재현 on 2022/01/10.
//

import Foundation

struct URLManager {
    private let hostAddress = "https://market-training.yagom-academy.kr/api/products"

    // MARK: - 상품 등록
    mutating func makeURL() -> URL {
        guard let url = URL(string: hostAddress) else {
            preconditionFailure("Fail to make URL")
        }

        return url
    }

    // MARK: - 상품 리스트 조회
    mutating func makeURL(on page: Int) -> URL {
        var components = URLComponents(string: hostAddress)
        let pageNumber = URLQueryItem(name: "page-no", value: "\(page)")
        let itemsPerPage = URLQueryItem(name: "items-per-page", value: "10")
        components?.queryItems = [pageNumber, itemsPerPage]
        guard let url = components?.url else {
            preconditionFailure("Fail to make URL")
        }

        return url
    }

    // MARK: - 상품 상세 조회, 상품 수정
    mutating func makeURL(referTo productID: Int) -> URL {
        guard let url = URL(string: hostAddress) else {
            preconditionFailure("Fail to make URL")
        }

        return url.appendingPathComponent("\(productID)")
    }

    // MARK: - 상품 삭제 secret 조회
    mutating func makeURL(secretOf productID: Int) -> URL {
        guard let url = URL(string: hostAddress) else {
            preconditionFailure("Fail to make URL")
        }

        return url.appendingPathComponent("\(productID)").appendingPathComponent("secret")
    }

    // MARK: - 상품 삭제
    mutating func makeURL(delete productID: Int, coincideWith productSecret: String) -> URL {
        guard let url = URL(string: hostAddress) else {
            preconditionFailure("Fail to make URL")
        }
        return url.appendingPathComponent("\(productID)").appendingPathComponent(productSecret)
    }
}
