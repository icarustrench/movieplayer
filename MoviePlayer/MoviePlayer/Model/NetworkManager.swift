//
//  NetworkManager.swift
//  MoviePlayer
//
//  Created by Madeleine Sekar Putri Wijayanto on 04/10/24.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}

    func fetchMovies(completion: @escaping ([MovieCategory]?) -> Void) {
        guard let url = URL(string: "https://bootcamp-api-json-ten.vercel.app/api/json") else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }

            do {
                let categoriesResponse = try JSONDecoder().decode(CategoriesResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(categoriesResponse.categories)
                }
            } catch {
                print("Failed to decode: \(error)")
                completion(nil)
            }
        }.resume()
    }
}
