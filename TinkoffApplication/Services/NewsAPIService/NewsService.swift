//
//  NewsService.swift
//  TinkoffApplication
//
//  Created by Дмитрий Пермяков on 22.07.2023.
//

import Foundation

protocol AnyNewsService: AnyObject {
    func getAppleNews(from dateFrom: String?, to dateTo: String?) async throws -> News
    func getAppleNews(from dateFrom: String?, to dateTo: String?, completion: @escaping (Result<News, Error>) -> Void)
}

class NewsService: AnyNewsService {
    static let shared = NewsService()
    private init() {}
    
    private let apiKey   = "5bb077a0181341b99bf6345c40f3b2d9"
    private var dateFrom = "2023-08-03"
    private var dateTo   = "2023-08-04"
    
    func getAppleNews(
        from dateFrom: String? = nil,
        to dateTo: String? = nil
    ) async throws -> News {
        if let dateFrom = dateFrom {
            self.dateFrom = dateFrom
        }
        if let dateTo = dateTo {
            self.dateTo = dateTo
        }
        let urlString = "https://newsapi.org/v2/everything?q=apple&from=\(self.dateFrom)&to=\(self.dateTo)&sortBy=popularity&apiKey=\(apiKey)"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard
                let response = response as? HTTPURLResponse,
                    response.statusCode >= 200 &&
                    response.statusCode < 300
            else {
                throw URLError(.badServerResponse)
            }
            
            do {
                return try JSONDecoder().decode(News.self, from: data)
                
            } catch {
                throw error
            }
            
        } catch {
            throw error
        }
    }
    
    func getAppleNews(
        from dateFrom: String? = nil,
        to dateTo: String? = nil,
        completion: @escaping (Result<News, Error>) -> Void
    ) {
        if let dateFrom = dateFrom {
            self.dateFrom = dateFrom
        }
        if let dateTo = dateTo {
            self.dateTo = dateTo
        }
        
        let urlString = "https://newsapi.org/v2/everything?q=apple&from=\(self.dateFrom)&to=\(self.dateTo)&sortBy=popularity&apiKey=\(apiKey)"
        guard let url = URL(string: urlString) else {
            DispatchQueue.main.async {
                completion(.failure(URLError(.badURL)))
            }
            return
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            guard
                let response = response as? HTTPURLResponse,
                    response.statusCode >= 200 &&
                    response.statusCode < 300
            else {
                DispatchQueue.main.async {
                    completion(.failure(URLError(.badServerResponse)))
                }
                return
            }
            guard let data = data else {
                // FIXME: Придумать другую ошибку.
                DispatchQueue.main.async {
                    completion(.failure(URLError(.dataNotAllowed)))
                }
                return
            }
            do {
                let news = try JSONDecoder().decode(News.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(news))
                }
                
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
            
        }.resume()
    }
}
