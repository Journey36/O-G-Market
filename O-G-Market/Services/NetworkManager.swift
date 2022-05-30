//
//  Networking.swift
//  O-G-Market
//
//  Created by 재현 on 2022/01/14.
//

import UIKit
import Alamofire

actor NetworkManager {
    private let manager = URLManager()
    private let identifier = "3424eb5f-660f-11ec-8eff-b53506094baa"

    enum ConvertingError: Error {
        case convertingImageFailed
    }

    @discardableResult
    func fetch(pages startPage: Int) async throws -> Page {
        let url = try manager.makePageInquiryURL(startPage: startPage)
        let response = AF.request(url)
            .validate(statusCode: 200..<400)
            .serializingDecodable(Page.self)

        return try await response.value
    }

    @discardableResult
    func fetch(details productID: Int) async throws -> Post {
        let url = try manager.makeProductUpdateURL(productID: productID)
        let response = AF.request(url)
            .validate(statusCode: 200..<400)
            .serializingDecodable(Post.self)

        return try await response.value
    }

    @discardableResult
    func fetch(images url: URL) async throws -> UIImage {
        let response = AF.request(url)
            .validate(statusCode: 200..<400)
            .serializingData()

        if let image = try await UIImage(data: response.value) {
            return image
        } else {
            throw ConvertingError.convertingImageFailed
        }
    }

    @discardableResult
    func upload(content: Registration) async throws -> Post {
        let url = try manager.makeRegistrationURL()
        let encoder = JSONEncoder()
        guard let product = try? encoder.encode(content.product) else { throw AFError.invalidURL(url: url) }

        let boundary = UUID().uuidString.hashValue
        var body = Data()
        for index in 0..<content.images.count {
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"images\"; filename=\"img\(index).jpeg\"\r\n")
            body.append("Content-Type: image/jpeg\r\n\r\n")
            body.append(content.images[index])
            body.append("\r\n")
        }

        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"params\"\r\n\r\n")
        body.append(product)
        body.append("\r\n")
        body.append("--\(boundary)--\r\n")

        var request = URLRequest(url: url)

        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue("\(identifier)", forHTTPHeaderField: "identifier")
        request.httpBody = body

        let (data, response) = try await URLSession.shared.data(for: request)
        if let response = response as? HTTPURLResponse {
            guard (200...399).contains(response.statusCode) else { throw AFError.invalidURL(url: url) }
        }

        do {
            let decoder = JSONDecoder()
            return try decoder.decode(Post.self, from: data)
        } catch { throw error }
    }

    @discardableResult
    func upload(productID: Int, userSecret: String) async throws -> String {
        let url = try manager.makeProductSecretInquiryURL(productID: productID)
        let identifier = HTTPHeader(name: "identifier", value: identifier)
        let vendor = Vendor(secret: userSecret)
        let response = AF.request(url, method: .post, parameters: vendor, encoder: .json, headers: [identifier])
            .validate(statusCode: 200..<400)
            .serializingString()

        return try await response.value
    }

    @discardableResult
    func update(productID: Int, content: Update) async throws -> Post {
        let url = try manager.makeProductUpdateURL(productID: productID)
        let identifier = HTTPHeader(name: "identifier", value: identifier)
        let response = AF.request(url, method: .patch, parameters: content, encoder: .json, headers: [identifier])
            .validate(statusCode: 200..<400)
            .serializingDecodable(Post.self)

        return try await response.value
    }

    @discardableResult
    func delete(productID: Int, productSecret: String) async throws -> Post {
        let url = try manager.makeProductDeletionURL(productID: productID, productSecret: productSecret)
        let identifier = HTTPHeader(name: "identifier", value: identifier)
        let response = AF.request(url, method: .delete, headers: [identifier])
            .validate(statusCode: 200..<499)
            .serializingDecodable(Post.self)

        return try await response.value
    }
}
