//
//  Protocols.swift
//  Daily Bugle
//
//  Created by J Dayasagar on 14/04/23.
//

import Foundation


protocol GetNews{
    func getNews(category: Category)
}

protocol UserConfigurationDelegate{
    var userUID: String? { get }
}

