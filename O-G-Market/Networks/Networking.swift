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
            guard let error = error else {
                return
            }

            guard let response = response as? HTTPURLResponse, (200...399).contains(response.statusCode) else {
                return
            }

            guard let data = data else {
                return completion(.failure(error))
            }

            guard let productSecretKey = String(data: data, encoding: .utf8) else {
                return
            }

            completion(.success(productSecretKey))
        }

        task.resume()
    }
}
