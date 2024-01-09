//
//  Extensions.swift
//  Daily Bugle
//
//  Created by J Dayasagar on 30/12/22.
//

import Foundation
import UIKit

extension UIViewController {
    
    func isVisible() -> Bool {
        return self.isViewLoaded && self.view.window != nil
    }
    
    func getDocumentsDirectory() -> URL {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        // just send back the first one, which ought to be the only one
        return paths[0]
    }
    
}

extension UIImageView {
        public func maskCircle(anyImage: UIImage) {
      self.contentMode = UIView.ContentMode.scaleToFill
           // Make Image Corners Rounded
      self.layer.cornerRadius = 80
      self.clipsToBounds = true
      self.layer.borderWidth = 3
      self.layer.borderColor = UIColor.lightGray.cgColor
      self.image = anyImage
  }
}

extension UIViewController {
   
    // With this extension you can access the MainViewController from the child view controllers.
    func revealViewController() -> MainVC? {
        var viewController: UIViewController? = self
        if viewController != nil && viewController is MainVC {
            return viewController! as? MainVC
        }
        while (!(viewController is MainVC) && viewController?.parent != nil) {
            viewController = viewController?.parent
        }
        if viewController is MainVC {
            return viewController as? MainVC
        }
        return nil
    }
}



extension LoginController : UITextFieldDelegate {
    
    /**
     * Called when 'return' key pressed. return NO to ignore.
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    /**
     * Called when the user click on the view (outside the UITextField).
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}



extension UIViewController {
    
    func showMessage(title: String) {
        let alert = UIAlertController(title: "Message", message: title, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func setupToHideKeyboardOnTapOnView() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))

        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
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


extension Int {
    var isEven: Bool { isMultiple(of: 2) }
    var isOdd:  Bool { !isEven }
}




extension Int {
    public var isPrime: Bool {
        guard self > 1 else {
          return false
        }
        for i in 2..<self {
          if self % i == 0 {
            return false
          }
        }
        return true
      }
}





extension UIImageView {
    
    func loadImageUsingCache(withUrl urlString : String) {
        let imageCache = NSCache<NSString, AnyObject>()
        let url = URL(string: urlString)
        self.image = nil
        // check cached image
        if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage {
            self.image = cachedImage
            return
        }
        // if not, download image from url
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    imageCache.setObject(image, forKey: urlString as NSString)
                    self.image = image
                }
            }
        }).resume()
    }
}
