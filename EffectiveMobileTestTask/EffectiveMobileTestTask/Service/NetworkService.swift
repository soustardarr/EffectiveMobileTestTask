//
//  NetworkService.swift
//  EffectiveMobileTestTask
//
//  Created by Ruslan Kozlov on 16.11.2024.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case emptyData
    case decodingFailed
}

protocol NetworkServiceProtocol {
    func fetchData(completion: @escaping (Result<[Task], Error>) -> Void)
}

final class NetworkService: NetworkServiceProtocol {

    private let baseURL = "https://dummyjson.com/todos"
    private let session: URLSession

    init(session: URLSession = URLSession.shared) {
        self.session = session
    }

    func fetchData(completion: @escaping (Result<[Task], any Error>) -> Void) {
        guard let url = URL(string: baseURL) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        let request = URLRequest(url: url)

        session.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.invalidResponse))
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.emptyData))
                }
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(TodoResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedResponse.todos))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.decodingFailed))
                }
            }
        }.resume()
    }
}
