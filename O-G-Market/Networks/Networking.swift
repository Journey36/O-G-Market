//
//  Networking.swift
//  O-G-Market
//
//  Created by 재현 on 2022/01/14.
//

import Alamofire
import UIKit

final class Networking {
    static var `default` = Networking()

    private var manager = URLManager()

    private init() { }

    // MARK: - GET
    func requestGET(with productID: Int, then completion: @escaping (Result<PostingInfo, Error>) -> Void) {
        let url = manager.makeURL(referTo: productID)

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                return
            }

            guard let response = response as? HTTPURLResponse, (200...399).contains(response.statusCode) else {
                return
            }

            do {
                guard let data = data else {
                    return
                }

                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(PostingInfo.self, from: data)

                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }

    func requestGET(on page: Int = 1, then completion: @escaping (Result<ProductList, Error>) -> Void) {
        let url = manager.makeURL(on: page)
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                return
            }

            guard let response = response as? HTTPURLResponse, (200...399).contains(response.statusCode) else {
                return
            }

            do {
                guard let data = data else {
                    return
                }

                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(ProductList.self, from: data)

                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }

    // MARK: - POST
    func requestPOST(with parameter: Product, images: [UIImage], then completion: @escaping (Result<Data, Error>) -> Void) {
        let url = manager.makeURL()

        let encoder = JSONEncoder()
        guard let encodedData = try? encoder.encode(parameter) else {
            return
        }

        let imageDatum = images.compactMap { $0.pngData() }

        let boundary = UUID().uuidString.hashValue
        var body = Data()
        for index in 0..<imageDatum.count {
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"images\"; filename=\"img\(index).png\"\r\n")
            body.append("Content-Type: image/png\r\n\r\n")
            body.append(imageDatum[index])
            body.append("\r\n")
        }

        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"params\"\r\n\r\n")
        body.append(encodedData)
        body.append("\r\n")
        body.append("--\(boundary)--\r\n")

        var request = URLRequest(url: url)

        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue("3424eb5f-660f-11ec-8eff-b53506094baa", forHTTPHeaderField: "identifier")
        request.httpBody = body

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                return
            }

            guard let response = response as? HTTPURLResponse, (200...399).contains(response.statusCode) else {
                return
            }

            guard let data = data else {
                return completion(.failure(error!))
            }

            completion(.success(data))
        }

        task.resume()
    }

    func requestPOST(with productID: Int, then completion: @escaping (Result<String, Error>) -> Void) {
        let url = manager.makeURL(secretOf: productID)

        let vendor = Vendor()

        let encoder = JSONEncoder()
        guard let secretKey = try? encoder.encode(vendor) else {
            return
        }

        guard var request = try? URLRequest(url: url, method: .post) else {
            return
        }

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("3424eb5f-660f-11ec-8eff-b53506094baa", forHTTPHeaderField: "identifier")
        request.httpBody = secretKey


        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                return
            }

            guard let response = response as? HTTPURLResponse, (200...399).contains(response.statusCode) else {
                return
            }

            guard let data = data else {
                return completion(.failure(error!))
            }

            guard let productSecretKey = String(data: data, encoding: .utf8) else {
                return
            }

            completion(.success(productSecretKey))
        }

        task.resume()
    }

    // MARK: - PATCH
    func requestPATCH(with productID: Int, params: ProductUpdate, then completion: @escaping (Result<PostingInfo, Error>) -> Void) {
        let url = manager.makeURL(referTo: productID)

        let encoder = JSONEncoder()
        guard let encodedData = try? encoder.encode(params) else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("3424eb5f-660f-11ec-8eff-b53506094baa", forHTTPHeaderField: "identifier")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = encodedData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("Error!")
                return
            }

            guard let response = response as? HTTPURLResponse, (200...399).contains(response.statusCode) else {
                print("Response error!")
                return
            }

            do {
                guard let data = data else {
                    return
                }

                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(PostingInfo.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }

    // MARK: - DELETE
    func requestDELETE(at productID: Int, coincideWith productSecret: String, then completion: @escaping (Result<PostingInfo, Error>) -> Void) {
        let url = manager.makeURL(delete: productID, coincideWith: productSecret)

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("3424eb5f-660f-11ec-8eff-b53506094baa", forHTTPHeaderField: "identifier")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                return
            }

            guard let response = response as? HTTPURLResponse, (200...399).contains(response.statusCode) else {
                return
            }

            do {
                guard let data = data else {
                    return
                }

                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(PostingInfo.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }
}
