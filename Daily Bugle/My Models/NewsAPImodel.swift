//
//  NewsAPImodel.swift
//  Daily Bugle
//
//  Created by J Dayasagar on 07/01/23.
//

import Foundation

struct NewsAPI: Decodable{
    let totalResults: Int?
    let articles: [Article]?
//    let result:String
}

struct Article: Decodable{
    
    let author :String?
    let title: String?
    let description: String?
    let url: URL?
    let urlToImage: URL?
    let publishedAt: String?
    let content : String?
    let source : Source?
}

struct Source: Decodable {
    let id : String?
    let name : String?
    
    enum CodingKeys : String, CodingKey{
        case id = "id"
        case name = "name"
    }
}
