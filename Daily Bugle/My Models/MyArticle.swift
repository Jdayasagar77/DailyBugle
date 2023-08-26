//
//  MyArticle.swift
//  Daily Bugle
//
//  Created by J Dayasagar on 23/02/23.
//

import Foundation
import UIKit

struct MyArticle {
    
    let id = UUID()
    let image: Data
    let author: String
    let title, description: String
    let url: String
    let urlToImage: String
    let publishedAt: String
    let content: String
    
}
