//
//  Extensions.swift
//  Daily Bugle
//
//  Created by J Dayasagar on 30/12/22.
//

import Foundation
import UIKit


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

extension MainVC: UIGestureRecognizerDelegate {
    @objc func TapGestureRecognizer(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            if self.isExpanded {
                self.sideMenuState(expanded: false)
            }
        }
    }

    // Close side menu when you tap on the shadow background view
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: self.hamburgerViewController.view))! {
            return false
        }
        return true
    }
    
    @objc func handlePanGesture(sender: UIPanGestureRecognizer) {
            
            // ...

            let position: CGFloat = sender.translation(in: self.view).x
            let velocity: CGFloat = sender.velocity(in: self.view).x

            switch sender.state {
            case .began:

                // If the user tries to expand the menu more than the reveal width, then cancel the pan gesture
                if velocity > 0, self.isExpanded {
                    sender.state = .cancelled
                }

                // If the user swipes right but the side menu hasn't expanded yet, enable dragging
                if velocity > 0, !self.isExpanded {
                    self.draggingIsEnabled = true
                }
                // If user swipes left and the side menu is already expanded, enable dragging they collapsing the side menu)
                else if velocity < 0, self.isExpanded {
                    self.draggingIsEnabled = true
                }

                if self.draggingIsEnabled {
                    // If swipe is fast, Expand/Collapse the side menu with animation instead of dragging
                    let velocityThreshold: CGFloat = 550
                    if abs(velocity) > velocityThreshold {
                        self.sideMenuState(expanded: self.isExpanded ? false : true)
                        self.draggingIsEnabled = false
                        return
                    }

                    if self.revealHamMenuOnTop {
                        self.panBaseLocation = 0.0
                        if self.isExpanded {
                            self.panBaseLocation = self.hamburgerWidth
                        }
                    }
                }

            case .changed:

                // Expand/Collapse side menu while dragging
                if self.draggingIsEnabled {
                    if self.revealHamMenuOnTop {
                        // Show/Hide shadow background view while dragging
                        let xLocation: CGFloat = self.panBaseLocation + position
                        let percentage = (xLocation * 150 / self.hamburgerWidth) / self.hamburgerWidth

                        let alpha = percentage >= 0.6 ? 0.6 : percentage
                        self.hamMenuShadowView.alpha = alpha

                        // Move side menu while dragging
                        if xLocation <= self.hamburgerWidth {
                            self.hamMenuTrailingConstraint.constant = xLocation - self.hamburgerWidth
                        }
                    }
                    else {
                        if let recogView = sender.view?.subviews[1] {
                           // Show/Hide shadow background view while dragging
                            let percentage = (recogView.frame.origin.x * 150 / self.hamburgerWidth) / self.hamburgerWidth

                            let alpha = percentage >= 0.6 ? 0.6 : percentage
                            self.hamMenuShadowView.alpha = alpha

                            // Move side menu while dragging
                            if recogView.frame.origin.x <= self.hamburgerWidth, recogView.frame.origin.x >= 0 {
                                recogView.frame.origin.x = recogView.frame.origin.x + position
                                sender.setTranslation(CGPoint.zero, in: view)
                            }
                        }
                    }
                }
            case .ended:
                self.draggingIsEnabled = false
                // If the side menu is half Open/Close, then Expand/Collapse with animationse with animation
                if self.revealHamMenuOnTop {
                    let movedMoreThanHalf = self.hamMenuTrailingConstraint.constant > -(self.hamburgerWidth * 0.5)
                    self.sideMenuState(expanded: movedMoreThanHalf)
                }
                else {
                    if let recogView = sender.view?.subviews[1] {
                        let movedMoreThanHalf = recogView.frame.origin.x > self.hamburgerWidth * 0.5
                        self.sideMenuState(expanded: movedMoreThanHalf)
                    }
                }
            default:
                break
            }
        }}

extension LoginController : UITextFieldDelegate{
    
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
    
    func setupToHideKeyboardOnTapOnView()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))

        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard(){
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




let imageCache = NSCache<NSString, AnyObject>()

extension UIImageView {
    
    func loadImageUsingCache(withUrl urlString : String) {
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
