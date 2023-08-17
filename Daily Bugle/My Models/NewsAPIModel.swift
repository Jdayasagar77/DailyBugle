//
//  NewsAPIModel.swift
//  Daily Bugle
//
//  Created by J Dayasagar on 20/02/23.
//


import Foundation
import UIKit


// MARK: - NewsAPI
struct NewsAPI: Codable {
    let status: String?
    let totalResults: Int?
    let articles: [Article]?
 
}

// MARK: - Article
struct Article: Codable {
    let id = UUID()
    let source: Source?
    let author: String?
    let title, description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
    
    enum CodingKeys: String, CodingKey {

        case author = "author"
        case source = "source"
        case title = "title"
        case description = "description"
        case url = "url"
        case urlToImage = "urlToImage"
        case publishedAt = "publishedAt"
        case content = "content"

    }
   
  
}


// MARK: - Source
struct Source: Codable{
    let id: String?
    let name: String?
}



//https://newsapi.org/v2/top-headlines?country=us&apiKey=0b5daaadb04e4948b3bfc21ebaf29169
