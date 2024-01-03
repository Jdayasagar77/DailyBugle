//
//  Utility.swift
//  Daily Bugle
//
//  Created by J Dayasagar on 17/08/23.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

struct DefaultKeys {
    static let isUserLogin = "IsUserLogin"
    static let savedUser = "savedUser"
    static let userUID = "userUID"
}


final class Utility: NSObject {
    let auth = Auth.auth()
    let db = Firestore.firestore()
    let newsConnection = NewsAPIBackend.shared
    
    static let shared = Utility()
    
    /// Set data in default when user get loged in
    /// - Parameters:
    ///   - userEmail: Logged in user email id
    ///   - onCoreDatabase: true if user login from coredatabase
    ///
    
    func setDataWhenUserLogin(user:UserModel, userUID: String) {
        do {
            // 1
            let encodedData = try JSONEncoder().encode(user)
            let userDefaults = UserDefaults.standard
            // 2
            userDefaults.set(encodedData, forKey: DefaultKeys.savedUser)
            UserDefaults.standard.setValue(true, forKey: DefaultKeys.isUserLogin)
            UserDefaults.standard.setValue(userUID, forKey: DefaultKeys.userUID)
            
            
        } catch {
            // Failed to encode Contact to Data
            debugPrint("An Error Occured : \(error) Failed to encode the data ")
        }
    }
    
    func getSavedUserData() -> UserModel? {
        
        var myData:UserModel? = UserModel()
        if let savedData = UserDefaults.standard.object(forKey: DefaultKeys.savedUser) as? Data {
            
            do {
                let savedUser = try JSONDecoder().decode(UserModel.self, from: savedData)
                myData = savedUser
            } catch {
                // Failed to convert Data to Contact
                debugPrint("Failed to decode: \(error)")
            }
        }
        return myData ?? nil
    }
    
    
    
    /// Loout the user
    func logout() {
        UserDefaults.standard.setValue(false, forKey: DefaultKeys.isUserLogin)
        UserDefaults.standard.removeObject(forKey: DefaultKeys.savedUser)
        UserDefaults.standard.removeObject(forKey: DefaultKeys.userUID)
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
