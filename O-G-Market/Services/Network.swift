//
//  Networking.swift
//  O-G-Market
//
//  Created by 재현 on 2022/01/14.
//

import UIKit

final class Network {
    private var manager = URLManager()

    private enum HTTPRequestMethods: CustomStringConvertible {
        case get
        case post
        case patch
        case delete

        var description: String {
            switch self {
            case .get:
                return "GET"
            case .post:
                return "POST"
            case .patch:
                return "PATCH"
            case .delete:
                return "DELETE"
            }
        }
    }

    private enum HTTPHeaders {
        static let identifier = "identifier"
        static let contentType = "Content-Type"
    }

    // FIXME: 임시 에러 코드
    enum NetworkError: Error {
        case badRequest
    }

    // MARK: - GET
    func fetchDetails(of productID: Int) async throws -> Post {
        let url = manager.generateURL(toInquireOrUpdate: productID)

        let (data, response) = try await URLSession.shared.data(from: url)
        if let response = response as? HTTPURLResponse {
            guard (200...399).contains(response.statusCode) else { throw NetworkError.badRequest }
        }

        do {
            let decoder = JSONDecoder()
            return try decoder.decode(Post.self, from: data)
        } catch { throw error }
    }

    func fetchPages(from startPage: Int) async throws -> Page {
        let url = manager.generateURL(toInquireFrom: startPage)

        let (data, response) = try await URLSession.shared.data(from: url)
        if let response = response as? HTTPURLResponse {
            guard (200...399).contains(response.statusCode) else { throw NetworkError.badRequest }
        }

        do {
            let decoder = JSONDecoder()
            return try decoder.decode(Page.self, from: data)
        } catch { throw error }
    }

    func fetchProductImages(from url: URL) async throws -> UIImage {
        let (data, response) = try await URLSession.shared.data(from: url)
        if let response = response as? HTTPURLResponse {
            guard (200...399).contains(response.statusCode) else { throw NetworkError.badRequest }
        }

        if let image = UIImage(data: data) {
            return image
        } else { throw NetworkError.badRequest }
    }

    // MARK: - POST
    func registerProduct(with info: Registration) async throws -> Post {
        let url = manager.generateURL()

        let encoder = JSONEncoder()
        guard let product = try? encoder.encode(info.product) else { throw NetworkError.badRequest }

        let boundary = UUID().uuidString.hashValue
        var body = Data()
        for index in 0..<info.images.count {
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"images\"; filename=\"img\(index).jpeg\"\r\n")
            body.append("Content-Type: image/jpeg\r\n\r\n")
            body.append(info.images[index])
            body.append("\r\n")
        }

        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"params\"\r\n\r\n")
        body.append(product)
        body.append("\r\n")
        body.append("--\(boundary)--\r\n")

        var request = URLRequest(url: url)

        request.httpMethod = String(describing: HTTPRequestMethods.post)
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: HTTPHeaders.contentType)
        request.setValue("\(Bundle.main.identifier)", forHTTPHeaderField: HTTPHeaders.identifier)
        request.httpBody = body

        let (data, response) = try await URLSession.shared.data(for: request)
        if let response = response as? HTTPURLResponse {
            guard (200...399).contains(response.statusCode) else { throw NetworkError.badRequest }
        }

        do {
            let decoder = JSONDecoder()
            return try decoder.decode(Post.self, from: data)
        } catch { throw error }
    }

    func inquireSecretKey(of productID: Int, with userPassword: String) async throws -> String {
        let url = manager.generateURL(toInquireSecretOf: productID)

        let vendor = Vendor(secret: userPassword)
        let encoder = JSONEncoder()
        guard let userSecretKey = try? encoder.encode(vendor) else { throw NetworkError.badRequest }

        var request = URLRequest(url: url)
        request.httpMethod = String(describing: HTTPRequestMethods.post)
        request.setValue("application/json", forHTTPHeaderField: HTTPHeaders.contentType)
        request.setValue(Bundle.main.identifier, forHTTPHeaderField: HTTPHeaders.identifier)
        request.httpBody = userSecretKey

        let (data, response) = try await URLSession.shared.data(for: request)
        if let response = response as? HTTPURLResponse {
            guard (200...399).contains(response.statusCode) else { throw NetworkError.badRequest }
        }

        if let productSecretKey = String(data: data, encoding: .utf8) {
            return productSecretKey
        } else { throw NetworkError.badRequest }
    }

    // MARK: - PATCH
    func updateInfo(of productID: Int, to newInfo: Update) async throws -> Post {
        let url = manager.generateURL(toInquireOrUpdate: productID)

        let encoder = JSONEncoder()
        guard let newInfo = try? encoder.encode(newInfo) else { throw NetworkError.badRequest }

        var request = URLRequest(url: url)
        request.httpMethod = String(describing: HTTPRequestMethods.patch)
        request.setValue("application/json", forHTTPHeaderField: HTTPHeaders.contentType)
        request.setValue(Bundle.main.identifier, forHTTPHeaderField: HTTPHeaders.identifier)
        request.httpBody = newInfo

        let (data, response) = try await URLSession.shared.data(for: request)
        if let response = response as? HTTPURLResponse {
            guard (200...399).contains(response.statusCode) else { throw NetworkError.badRequest }
        }

        do {
            let decoder = JSONDecoder()
            return try decoder.decode(Post.self, from: data)
        } catch { throw error }
    }

    // MARK: - DELETE
    func deletePost(of productID: Int, coincideWith productSecret: String) async throws -> Post {
        let url = manager.generateURL(toDelete: productID, coincidingWith: productSecret)

        var request = URLRequest(url: url)
        request.httpMethod = String(describing: HTTPRequestMethods.delete)
        request.setValue(Bundle.main.identifier, forHTTPHeaderField: HTTPHeaders.identifier)
        request.setValue("application/json", forHTTPHeaderField: HTTPHeaders.contentType)

        let (data, response) = try await URLSession.shared.data(for: request)
        if let response = response as? HTTPURLResponse {
            guard (200...399).contains(response.statusCode) else { throw NetworkError.badRequest }
        }

        do {
            let decoder = JSONDecoder()
            return try decoder.decode(Post.self, from: data)
        } catch { throw error }
    }
}
