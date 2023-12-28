//
//  UserModel.swift
//  Daily Bugle
//
//  Created by J Dayasagar on 18/12/22.
//

import Foundation
import UIKit

class UserModel: Codable {
    
    var profilePic: Data?
    var image: UIImage?
    var name: String?
    var email: String?
    var mobileNumber: String?
    var address: String?
    var state: String?
    var pincode: String?
    var password: String?
    var confirmPassword: String?
    
    init() {
        
    }

    enum CodingKeys: String, CodingKey {
        
        case profilePic = "profilePic"
        case name = "name"
        case email = "email"
        case mobileNumber = "mobileNumber"
        case address = "address"
        case state = "state"
        case password = "password"
        case pincode = "pincode"
        
    }

    
}
