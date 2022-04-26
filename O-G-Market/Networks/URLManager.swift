//
//  URLManager.swift
//  O-G-Market
//
//  Created by 재현 on 2022/01/10.
//

import Foundation

struct URLManager {
    private enum URLConvertingError {
        static let message = "모종의 이유로 URL을 만드는 데 실패했습니다."
    }

    private var baseURL: URL {
        guard let `self` = URL(string: "https://market-training.yagom-academy.kr/api/products") else { fatalError(URLConvertingError.message) }
        return self
    }

    // MARK: - 상품 등록
    func generateURL() -> URL {
        return baseURL
    }

    // MARK: - 상품 리스트 조회
    func generateURL(toInquireFrom page: Int) -> URL {
        guard var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false) else { fatalError(URLConvertingError.message) }

        let pageNumber = URLQueryItem(name: "page_no", value: "\(page)")
        let itemsPerPage = URLQueryItem(name: "items_per_page", value: "20")
        components.queryItems = [pageNumber, itemsPerPage]

        guard let url = components.url else {
            fatalError(URLConvertingError.message)
        }

        return url
    }

    // MARK: - 상품 상세 조회, 상품 수정
    func generateURL(toInquireOrUpdate productID: Int) -> URL {
        return baseURL.appendingPathComponent("\(productID)")
    }

    // MARK: - 상품 삭제 secret 조회
    func generateURL(toInquireSecretOf productID: Int) -> URL {
        return baseURL.appendingPathComponent("\(productID)").appendingPathComponent("secret")
    }

    // MARK: - 상품 삭제
    func generateURL(toDelete productID: Int, coincidingWith productSecret: String) -> URL {
        return baseURL.appendingPathComponent("\(productID)").appendingPathComponent(productSecret)
    }
}
