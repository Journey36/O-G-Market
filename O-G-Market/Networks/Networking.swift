//
//  Networking.swift
//  O-G-Market
//
//  Created by 재현 on 2022/01/14.
//

import Alamofire
import UIKit

enum Networking {
    private static var manager = URLManager()

    // MARK: - GET
    static func requestGET(with productID: Int, completion: @escaping (Result<PostingInfo, Error>) -> Void) {
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

    static func requestGET(on page: Int = 1, completion: @escaping (Result<ProductList, Error>) -> Void) {
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
}
