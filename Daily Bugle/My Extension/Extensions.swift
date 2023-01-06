//
//  Extensions.swift
//  Daily Bugle
//
//  Created by J Dayasagar on 30/12/22.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showMessage(title: String) {
        let alert = UIAlertController(title: "Message", message: title, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}




extension String {
    /// Validate email Id
    ///
    /// - Returns: true if email id is valid other wise false
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: self)
        return result
    }
}
