//
//  NewsAPImodel.swift
//  Daily Bugle
//
//  Created by J Dayasagar on 07/01/23.
//

import Foundation
import UIKit

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
    let urlToImage: String?
    let publishedAt: String?
    let content : String?
    let source : Source?
    
    func loadFrom() ->UIImage? {
        var myImage: UIImage?
        guard let url = URL(string: urlToImage ?? "") else { return UIImage() }
//
//        DispatchQueue.main.async { [weak self] in
            if let imageData = try? Data(contentsOf: url) {
                if let loadedImage = UIImage(data: imageData) {
                        myImage = loadedImage
                }
            }
            return myImage
    }//loadFrom Ends here
    
}

struct Source: Decodable {
    let id : String?
    let name : String?
    
    enum CodingKeys : String, CodingKey{
        case id = "id"
        case name = "name"
    }
}
