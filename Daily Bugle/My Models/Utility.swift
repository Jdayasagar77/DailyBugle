//
//  Utility.swift
//  Daily Bugle
//
//  Created by J Dayasagar on 17/08/23.
//

import Foundation

struct DefaultKeys {
    static let isUserLogin = "IsUserLogin"
    static let emailId = "emailId"
}

class Utility: NSObject {
    
    static let shared = Utility()
    
    /// Set data in default when user get loged in
    /// - Parameters:
    ///   - userEmail: Logged in user email id
    ///   - onCoreDatabase: true if user login from coredatabase
    func setDataWhenUserLogin(userEmail:String) {
        UserDefaults.standard.setValue(true, forKey: DefaultKeys.isUserLogin)
        UserDefaults.standard.setValue(userEmail, forKey: DefaultKeys.emailId)
    }
    
    /// Loout the user
    func logout() {
        UserDefaults.standard.setValue(false, forKey: DefaultKeys.isUserLogin)
        UserDefaults.standard.removeObject(forKey: DefaultKeys.emailId)
    }
    
    /// Check user login or not
    /// - Returns: true if user login otherwise return false
    func isUserLogin() -> Bool {
        if let isUserLogin = UserDefaults.standard.value(forKey: DefaultKeys.isUserLogin) as? Bool {
            return isUserLogin
        }
        return false
    }

}
