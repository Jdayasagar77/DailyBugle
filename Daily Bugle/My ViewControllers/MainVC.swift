//
//  MainVC.swift
//  Daily Bugle
//
//  Created by J Dayasagar on 03/12/22.
//

import UIKit

class MainVC: UIViewController {
    
    private var hamburgerVC = HamburgerVC(nibName: "HamburgerVC", bundle: nil)
    private var sideMenuShadowView: UIView!
    private var draggingIsEnabled: Bool = false
    private var panBaseLocation: CGFloat = 0.0
    private var sideMenuRevealWidth: CGFloat = 260
    private let paddingForRotation: CGFloat = 150
    private var isExpanded: Bool = false
    private var sideMenuTrailingConstraint: NSLayoutConstraint!
    private var revealSideMenuOnTop: Bool = true
    var gestureEnabled: Bool = true

    @IBOutlet var sideMenuBtn: UIBarButtonItem!
    @IBAction open func revealSideMenu() {
        self.sideMenuState(expanded: self.isExpanded ? false : true)
    }
    
   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.revealViewController()?.gestureEnabled = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            self.revealViewController()?.gestureEnabled = true
        }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
             let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
             panGestureRecognizer.delegate = self
             view.addGestureRecognizer(panGestureRecognizer)
                self.sideMenuShadowView = UIView(frame: self.view.bounds)
              self.sideMenuShadowView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
              self.sideMenuShadowView.backgroundColor = .black
              self.sideMenuShadowView.alpha = 0.0
              let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TapGestureRecognizer))
              tapGestureRecognizer.numberOfTapsRequired = 1
              tapGestureRecognizer.delegate = self
              self.sideMenuShadowView.addGestureRecognizer(tapGestureRecognizer)
        
              if self.revealSideMenuOnTop {
                  view.insertSubview(self.sideMenuShadowView, at: 1)
              }
        self.view.backgroundColor = #colorLiteral(red: 0.737254902, green: 0.1294117647, blue: 0.2941176471, alpha: 1)
        sideMenuBtn.target = revealViewController()
        sideMenuBtn.action = #selector(self.revealViewController()?.revealSideMenu)
        self.hamburgerVC.defaultHighlightedCell = 0 // Default Highlighted Cell
        self.hamburgerVC.delegate = self
        view.insertSubview(self.hamburgerVC.view, at: self.revealSideMenuOnTop ? 2 : 0)
        addChild(self.hamburgerVC)
        self.hamburgerVC.didMove(toParent: self)
        
        // Side Menu AutoLayout
        
        self.hamburgerVC.view.translatesAutoresizingMaskIntoConstraints = false
        
        if self.revealSideMenuOnTop {
            self.sideMenuTrailingConstraint = self.hamburgerVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -self.sideMenuRevealWidth - self.paddingForRotation)
            self.sideMenuTrailingConstraint.isActive = true
        }
        
        NSLayoutConstraint.activate([
            self.hamburgerVC.view.widthAnchor.constraint(equalToConstant: self.sideMenuRevealWidth),
            self.hamburgerVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            self.hamburgerVC.view.topAnchor.constraint(equalTo: view.topAnchor)
        ])
                
    }
    
}









extension MainVC: HamburgerVCDelegate, UIGestureRecognizerDelegate {
    
    @objc private func handlePanGesture(sender: UIPanGestureRecognizer) {
          
          guard gestureEnabled == true else { return }
        let position: CGFloat = sender.translation(in: self.view).x
        let velocity: CGFloat = sender.velocity(in: self.view).x

          // ...

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

                  if self.revealSideMenuOnTop {
                      self.panBaseLocation = 0.0
                      if self.isExpanded {
                          self.panBaseLocation = self.sideMenuRevealWidth
                      }
                  }
              }

          case .changed:

              // Expand/Collapse side menu while dragging
              if self.draggingIsEnabled {
                  if self.revealSideMenuOnTop {
                      // Show/Hide shadow background view while dragging
                      let xLocation: CGFloat = self.panBaseLocation + position
                      let percentage = (xLocation * 150 / self.sideMenuRevealWidth) / self.sideMenuRevealWidth

                      let alpha = percentage >= 0.6 ? 0.6 : percentage
                      self.sideMenuShadowView.alpha = alpha

                      // Move side menu while dragging
                      if xLocation <= self.sideMenuRevealWidth {
                          self.sideMenuTrailingConstraint.constant = xLocation - self.sideMenuRevealWidth
                      }
                  }
                  else {
                      if let recogView = sender.view?.subviews[1] {
                         // Show/Hide shadow background view while dragging
                          let percentage = (recogView.frame.origin.x * 150 / self.sideMenuRevealWidth) / self.sideMenuRevealWidth

                          let alpha = percentage >= 0.6 ? 0.6 : percentage
                          self.sideMenuShadowView.alpha = alpha

                          // Move side menu while dragging
                          if recogView.frame.origin.x <= self.sideMenuRevealWidth, recogView.frame.origin.x >= 0 {
                              recogView.frame.origin.x = recogView.frame.origin.x + position
                              sender.setTranslation(CGPoint.zero, in: view)
                          }
                      }
                  }
              }
          case .ended:
              self.draggingIsEnabled = false
              // If the side menu is half Open/Close, then Expand/Collapse with animationse with animation
              if self.revealSideMenuOnTop {
                  let movedMoreThanHalf = self.sideMenuTrailingConstraint.constant > -(self.sideMenuRevealWidth * 0.5)
                  self.sideMenuState(expanded: movedMoreThanHalf)
              }
              else {
                  if let recogView = sender.view?.subviews[1] {
                      let movedMoreThanHalf = recogView.frame.origin.x > self.sideMenuRevealWidth * 0.5
                      self.sideMenuState(expanded: movedMoreThanHalf)
                  }
              }
          default:
              break
          }
      }

    
    @objc func TapGestureRecognizer(sender: UITapGestureRecognizer) {
            if sender.state == .ended {
                if self.isExpanded {
                    self.sideMenuState(expanded: false)
                }
            }
        }

        // Close side menu when you tap on the shadow background view
        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
            if (touch.view?.isDescendant(of: self.hamburgerVC.view))! {
                return false
            }
            return true
        }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate { _ in
            if self.revealSideMenuOnTop {
                self.sideMenuTrailingConstraint.constant = self.isExpanded ? 0 : (-self.sideMenuRevealWidth - self.paddingForRotation)
            }
        }
    }
    
    func selectedCell(_ row: Int) {
        switch row {
        case 0:
            // Home
            self.showViewController(viewController: UINavigationController.self, scene: LoginController(nibName: "LoginController", bundle: nil))
        case 1:
            // Music
            self.showViewController(viewController: UINavigationController.self, scene: LoginController(nibName: "LoginController", bundle: nil))
        case 2:
            // Movies
            self.showViewController(viewController: UINavigationController.self,  scene: LoginController(nibName: "LoginController", bundle: nil))
        case 3:
            // Books
            self.showViewController(viewController: UINavigationController.self,  scene: LoginController(nibName: "LoginController", bundle: nil))
        case 4:
            // Profile
           
            present(LoginController(nibName: "LoginController", bundle: nil), animated: true, completion: nil)
        case 5:
            // Settings
            present(LoginController(nibName: "LoginController", bundle: nil), animated: true, completion: nil)
        case 6:
            // Like us on facebook
            present(LoginController(nibName: "LoginController", bundle: nil), animated: true, completion: nil)
        default:
            break
        }

        // Collapse side menu with animation
        DispatchQueue.main.async { self.sideMenuState(expanded: false) }
    }

    func showViewController<T: UIViewController>(viewController: T.Type, scene: UIViewController) -> () {
        // Remove the previous View
        for subview in view.subviews {
            if subview.tag == 99 {
                subview.removeFromSuperview()
            }
        }
       
        let vc = scene
        vc.view.tag = 99
        view.insertSubview(vc.view, at: self.revealSideMenuOnTop ? 0 : 1)
        addChild(vc)
        DispatchQueue.main.async {
            vc.view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                vc.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                vc.view.topAnchor.constraint(equalTo: self.view.topAnchor),
                vc.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                vc.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
            ])
        }
        if !self.revealSideMenuOnTop {
            if isExpanded {
                vc.view.frame.origin.x = self.sideMenuRevealWidth
            }
            if self.sideMenuShadowView != nil {
                vc.view.addSubview(self.sideMenuShadowView)
            }
        }
        vc.didMove(toParent: self)
    }

    func sideMenuState(expanded: Bool) {
        if expanded {
            self.animateSideMenu(targetPosition: self.revealSideMenuOnTop ? 0 : self.sideMenuRevealWidth) { _ in
                self.isExpanded = true
            }
            // Animate Shadow (Fade In)
            UIView.animate(withDuration: 0.5) {
                self.sideMenuShadowView.alpha = 0.6
                
            }
        }
        else {
            self.animateSideMenu(targetPosition: self.revealSideMenuOnTop ? (-self.sideMenuRevealWidth - self.paddingForRotation) : 0) { _ in
                self.isExpanded = false
            }
            // Animate Shadow (Fade Out)
            UIView.animate(withDuration: 0.5) {
                self.sideMenuShadowView.alpha = 0.0
            }
        }
    }

    func animateSideMenu(targetPosition: CGFloat, completion: @escaping (Bool) -> ()) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .layoutSubviews, animations: {
            if self.revealSideMenuOnTop {
                self.sideMenuTrailingConstraint.constant = targetPosition
                self.view.layoutIfNeeded()
            }
            else {
                self.view.subviews[1].frame.origin.x = targetPosition
            }
        }, completion: completion)
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



//        let myButton = UIBarButtonItem(image: UIImage(named: "ham-icon"), style: .done, target: revealViewController(), action: #selector(revealViewController()?.revealSideMenu))
//        // action:#selector(Class.MethodName) for swift 3
//      self.navigationItem.leftBarButtonItem = myButton
      //  self.navigationItem.title  = "Home"
     //   self.navigationItem.rightBarButtonItem = myButton1
        //self.navigationItem.leftBarButtonItem?.target = revealViewController()
        //self.navigationItem.leftBarButtonItem?.action = #selector(revealViewController()?.revealSideMenu)
