//
//  NewsAPIBackend.swift
//  Daily Bugle
//
//  Created by J Dayasagar on 11/04/23.
//

import Foundation

struct NewsAPIBackend {
    
    static let shared = NewsAPIBackend()
    private init() {}
    
    private let apiKey = "0b5daaadb04e4948b3bfc21ebaf29169"
    private let session = URLSession.shared
    private let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
    
    func fetchNews(category: Category, completion: @escaping(Result<[Article], APIError>) -> Void) {
        
        guard let url = generateNewsURL(from: category) else {
            let error = APIError.badURL
            completion(Result.failure(error))
            return
        }
        let task = URLSession.shared.dataTask(with: url) {(data , response, error) in
            
            if let error = error as? URLError {
                completion(Result.failure(APIError.url(error)))
            }else if  let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                completion(Result.failure(APIError.badResponse(statusCode: response.statusCode)))
            }else if let data = data {
                do {
                    let news = try jsonDecoder.decode(NewsAPI.self, from: data)
                    
                    completion(Result.success(news.articles!))
                    
                }catch {
                    completion(Result.failure(APIError.parsing(error as? DecodingError)))
                }
            }
        }
        
        task.resume()
        
    }
    
    
    private func generateNewsURL(from category: Category) -> URL? {
        var url = "https://newsapi.org/v2/top-headlines?"
        url += "apiKey=\(apiKey)"
        url += "&language=en"
        url += "&category=\(category.rawValue)"
        return URL(string: url)
    }
}


enum Category: String, CaseIterable {
    case general
    case business
    case technology
    case entertainment
    case sports
    case science
    case health
    case saved
    var text: String {
        if self == .general {
            return "Top Headlines"
        }
        return rawValue.capitalized
    }
    
    var categoryName: String {
        
        switch self {
            
        case .general:
            return "General"
            
        case .business:
            return "Business"
            
        case .technology:
            return "Technology"
            
        case .entertainment:
            return "Entertainment"
            
        case .sports:
            return "Sports"
            
        case .science:
            return "Science"
            
        case .health:
            return "Health"
            
        case .saved:
            return "Saved"
        }
    }
}

extension Category: Identifiable {
    var id: Self { self }
}
