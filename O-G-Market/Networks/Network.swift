//
//  Networking.swift
//  O-G-Market
//
//  Created by 재현 on 2022/01/14.
//

import UIKit

final class Network {
    typealias DataTaskCompletion = (Data?, URLResponse?, Error?) -> Void

    static var shared = Network()

    private var manager = URLManager()

    private init() {  }

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

    // MARK: - GET
    func requestGET(with productID: Int, then completion: @escaping (Result<ProductDetails, Error>) -> Void) {
        let url = manager.generateURL(toInquireAndModify: productID)

        let taskCompletion: DataTaskCompletion = { data, response, error in
            if error != nil, let response = response as? HTTPURLResponse {
                guard (200...399).contains(response.statusCode) else {
                    dump(response.statusCode)
                    return
                }
            }

            guard let data = data else {
                return
            }

            do {
                let productDetails = try JSONDecoder().decode(ProductDetails.self, from: data)
                completion(.success(productDetails))
            } catch {
                completion(.failure(error))
            }
        }

        URLSession.shared.dataTask(with: url, completionHandler: taskCompletion).resume()
    }

    func requestGET(on page: Int, then completion: @escaping (Result<Pages, Error>) -> Void) {
        let url = manager.generateURL(toInquire: page)

        let taskCompletion: DataTaskCompletion = { data, response, error in
            if error != nil, let response = response as? HTTPURLResponse {
                guard (200...399).contains(response.statusCode) else {
                    dump(response.statusCode)
                    return
                }
            }

            guard let data = data else {
                return
            }

            do {
                let pages = try JSONDecoder().decode(Pages.self, from: data)
                completion(.success(pages))
            } catch {
                completion(.failure(error))
            }
        }

        URLSession.shared.dataTask(with: url, completionHandler: taskCompletion).resume()
    }

    func getProductImages(from url: URL, then completion: @escaping (Result<UIImage, Error>) -> Void) {
        let taskCompletion: DataTaskCompletion = { data, response, error in
            if error != nil, let response = response as? HTTPURLResponse {
                guard (200...399).contains(response.statusCode) else {
                    dump(response.statusCode)
                    return
                }
            }

            guard let data = data else {
                return
            }

            if let image = UIImage(data: data) {
                completion(.success(image))
            } else {
                // FIXME: Error - Image Converting Error
                completion(.failure(error!))
            }
        }

        URLSession.shared.dataTask(with: url, completionHandler: taskCompletion).resume()
    }

    // MARK: - POST
    func requestPOST(with parameter: ProductCreation, then completion: @escaping (Result<ProductDetails, Error>) -> Void) {
        let url = manager.generateURL()

        guard let encodedData = try? JSONEncoder().encode(parameter.product) else {
            return
        }

        let boundary = UUID().uuidString.hashValue
        var body = Data()
        for index in 0..<parameter.images.count {
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"images\"; filename=\"img\(index).jpeg\"\r\n")
            body.append("Content-Type: image/jpeg\r\n\r\n")
            body.append(parameter.images[index])
            body.append("\r\n")
        }

        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"params\"\r\n\r\n")
        body.append(encodedData)
        body.append("\r\n")
        body.append("--\(boundary)--\r\n")

        var request = URLRequest(url: url)

        request.httpMethod = String(describing: HTTPRequestMethods.post)
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: HTTPHeaders.contentType)
        request.setValue("\(Bundle.main.identifier)", forHTTPHeaderField: HTTPHeaders.identifier)
        request.httpBody = body

        let taskCompletion: DataTaskCompletion = { data, response, error in
            if error != nil, let response = response as? HTTPURLResponse {
                guard (200...399).contains(response.statusCode) else {
                    dump(response.statusCode)
                    return
                }
            }

            guard let data = data else {
                return
            }

            do {
                let decodedData = try JSONDecoder().decode(ProductDetails.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }

        URLSession.shared.dataTask(with: request, completionHandler: taskCompletion).resume()
    }

    func requestPOST(with productID: Int, userSecret: String, then completion: @escaping (Result<String, Error>) -> Void) {
        let url = manager.generateURL(toInquireSecretOf: productID)

        let vendor = Vendor(secret: userSecret)

        guard let userSecretKey = try? JSONEncoder().encode(vendor) else {
            return
        }

        var request = URLRequest(url: url)

        request.httpMethod = String(describing: HTTPRequestMethods.post)
        request.setValue("application/json", forHTTPHeaderField: HTTPHeaders.contentType)
        request.setValue(Bundle.main.identifier, forHTTPHeaderField: HTTPHeaders.identifier)
        request.httpBody = userSecretKey

        let taskCompletion: DataTaskCompletion = { data, response, error in
            if error != nil, let response = response as? HTTPURLResponse {
                guard (200...399).contains(response.statusCode) else {
                    dump(response.statusCode)
                    return
                }
            }

            guard let data = data else {
                // FIXME: Error - Key가 맞지 않음
                completion(.failure(error!))
                return
            }

            guard let productSecretKey = String(data: data, encoding: .utf8) else {
                return
            }

            completion(.success(productSecretKey))
        }

        URLSession.shared.dataTask(with: request, completionHandler: taskCompletion).resume()
    }

    // MARK: - PATCH
    func requestPATCH(with productID: Int, params: ProductUpdate, then completion: @escaping (Result<ProductDetails, Error>) -> Void) {
        let url = manager.generateURL(toInquireAndModify: productID)

        let encoder = JSONEncoder()
        guard let encodedData = try? encoder.encode(params) else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = String(describing: HTTPRequestMethods.patch)
        request.setValue("\(Bundle.main.identifier)", forHTTPHeaderField: HTTPHeaders.identifier)
        request.setValue("application/json", forHTTPHeaderField: HTTPHeaders.contentType)
        request.httpBody = encodedData

        let taskCompletion: DataTaskCompletion = { data, response, error in
            if error != nil, let response = response as? HTTPURLResponse {
                guard (200...399).contains(response.statusCode) else {
                    dump(response.statusCode)
                    return
                }
            }

            guard let data = data else {
                return
            }

            do {
                let decodedData = try JSONDecoder().decode(ProductDetails.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }

        URLSession.shared.dataTask(with: request, completionHandler: taskCompletion).resume()
    }

    // MARK: - DELETE
    func requestDELETE(at productID: Int, coincideWith productSecret: String, then completion: @escaping (Result<ProductDetails, Error>) -> Void) {
        let url = manager.generateURL(toDelete: productID, coincidingWith: productSecret)

        var request = URLRequest(url: url)
        request.httpMethod = String(describing: HTTPRequestMethods.delete)
        request.setValue("\(Bundle.main.identifier)", forHTTPHeaderField: HTTPHeaders.identifier)
        request.setValue("application/json", forHTTPHeaderField: HTTPHeaders.contentType)

        let taskCompletion: DataTaskCompletion = { data, response, error in
            if error != nil, let response = response as? HTTPURLResponse {
                guard (200...399).contains(response.statusCode) else {
                    dump(response.statusCode)
                    return
                }
            }

            guard let data = data else {
                return
            }

            do {
                let decodedData = try JSONDecoder().decode(ProductDetails.self, from: data)
                // TODO: 삭제처리만 하면되므로 고민해보기
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }

        URLSession.shared.dataTask(with: request, completionHandler: taskCompletion).resume()
    }
}
