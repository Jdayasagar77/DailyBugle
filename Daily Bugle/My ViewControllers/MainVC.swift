//
//  MainVC.swift
//  Daily Bugle
//
//  Created by J Dayasagar on 03/12/22.
//

import UIKit

class MainVC: UIViewController {
    
    var isLoading: Bool = true
    var currentUser: UserModel?
    var errorMessage: String? = nil
    var myArticles: [Article]?
    let newsConnection = NewsAPIBackend.shared
    @IBOutlet weak var mainTable: UITableView!
    @IBOutlet var hamburgerBtn: UIBarButtonItem!
    var hamburgerViewController = HamburgerVC.init(nibName: "HamburgerVC", bundle: nil)
     var hamburgerWidth: CGFloat = 260
     let paddingForRotation: CGFloat = 150
    var isExpanded: Bool = false
    // Expand/Collapse the side menu by changing trailing's constant
     var hamMenuTrailingConstraint: NSLayoutConstraint!
     var revealHamMenuOnTop: Bool = true
     var hamMenuShadowView: UIView!
     var draggingIsEnabled: Bool = false
     var panBaseLocation: CGFloat = 0.0
   
    
    @IBAction open func revealSideMenu() {
        self.sideMenuState(expanded: self.isExpanded ? false : true)
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        newsConnection.fetchNews(category: Category.science) { [unowned self] result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    // print(error.description)
                    print(error)
                case .success(let news):
                    print("--- success with \(news.count)")
                    self.myArticles = news
                    self.mainTable.reloadData()
                }
            }
        }
    }
   
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.mainTable.register(UINib(nibName: "NewsFeedCell", bundle: nil), forCellReuseIdentifier: "NewsFeedCell")
        self.mainTable.delegate = self
        self.mainTable.dataSource = self
        self.mainTable.estimatedRowHeight = 300
                self.hamburgerViewController.defaultHighlightedCell = 0 // Default Highlighted Cell
                self.hamburgerViewController.hamDelegate = self
                view.insertSubview(self.hamburgerViewController.view, at: self.revealHamMenuOnTop ? 2 : 0)
                addChild(self.hamburgerViewController)
                self.hamburgerViewController.didMove(toParent: self)
                // Side Menu AutoLayout
                self.hamburgerViewController.view.translatesAutoresizingMaskIntoConstraints = false

                if self.revealHamMenuOnTop {
                    self.hamMenuTrailingConstraint = self.hamburgerViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -self.hamburgerWidth - self.paddingForRotation)
                    self.hamMenuTrailingConstraint.isActive = true
                }
                NSLayoutConstraint.activate([
                    self.hamburgerViewController.view.widthAnchor.constraint(equalToConstant: self.hamburgerWidth),
                    self.hamburgerViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                    self.hamburgerViewController.view.topAnchor.constraint(equalTo: view.topAnchor)
                ])

        self.hamMenuShadowView = UIView(frame: self.view.bounds)
               self.hamMenuShadowView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
               self.hamMenuShadowView.backgroundColor = .black
               self.hamMenuShadowView.alpha = 0.0
               let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TapGestureRecognizer))
               tapGestureRecognizer.numberOfTapsRequired = 1
               tapGestureRecognizer.delegate = self
               self.hamMenuShadowView.addGestureRecognizer(tapGestureRecognizer)
               if self.revealHamMenuOnTop {
                   view.insertSubview(self.hamMenuShadowView, at: 1)
               }

        // Side Menu Gestures
               let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
               panGestureRecognizer.delegate = self
               view.addGestureRecognizer(panGestureRecognizer)
               
               // Default Main View Controller
//               showViewController(viewController: UINavigationController.self, storyboardId: "HomeNavID")
        hamburgerBtn.target = revealViewController()
        hamburgerBtn.action = #selector(revealViewController()?.revealSideMenu)

    }
}





extension MainVC : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.myArticles != nil {
            return self.myArticles?.count ?? 0
        }
        else {return 0}
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.mainTable.dequeueReusableCell(withIdentifier: "NewsFeedCell") as? NewsFeedCell
        cell?.articleTitle.text = self.myArticles?[indexPath.row].title
        cell?.articlePublished.text =  self.myArticles?[indexPath.row].publishedAt ?? ""
        if self.myArticles?[indexPath.row].urlToImage != nil {
        cell?.articleImage.loadImageUsingCache(withUrl: (self.myArticles?[indexPath.row].urlToImage)!)
        } else {
            cell?.articleImage.image = UIImage(named: "Loading")
        }
        if indexPath.row.isOdd {
            cell?.contentView.backgroundColor = .gray
            cell?.articleTitle.textColor = .white
            cell?.articlePublished.textColor = .white
            cell?.saveButton.tintColor = .white
        }
        cell?.handler =  {
            
        }
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}


extension MainVC : HamburgerVCDelegate {
    
    func selectedCell(_ row: Int) {
            switch row {
            case 0:
                // Technology
                self.showViewController(viewController: UINavigationController.self, nibName: "")
            case 1:
                // Business
                self.showViewController(viewController: UINavigationController.self, nibName: "")
            case 2:
                // Entertainment
                self.showViewController(viewController: UINavigationController.self, nibName: "")
            case 3:
                // Science
                self.showViewController(viewController: UINavigationController.self, nibName: "")
            case 4:
                // Saved
                self.showViewController(viewController: UINavigationController.self, nibName: "")
        
            default:
                break
            }

            // Collapse side menu with animation
            DispatchQueue.main.async { self.sideMenuState(expanded: false) }
        }

        func showViewController<T: UIViewController>(viewController: T.Type, nibName: String) -> () {
            // Remove the previous View
            for subview in view.subviews {
                if subview.tag == 99 {
                    subview.removeFromSuperview()
                }
            }
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: storyboardId) as! T
            let vc = UIViewController(nibName: nibName, bundle: nil)
            vc.view.tag = 99
            view.insertSubview(vc.view, at: self.revealHamMenuOnTop ? 0 : 1)
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
            if !self.revealHamMenuOnTop {
                if isExpanded {
                    vc.view.frame.origin.x = self.hamburgerWidth
                }
                if self.hamMenuShadowView != nil {
                    vc.view.addSubview(self.hamMenuShadowView)
                }
            }
            vc.didMove(toParent: self)
        }

        func sideMenuState(expanded: Bool) {
            if expanded {
                self.animateSideMenu(targetPosition: self.revealHamMenuOnTop ? 0 : self.hamburgerWidth) { _ in
                    self.isExpanded = true
                }
                // Animate Shadow (Fade In)
                UIView.animate(withDuration: 0.5) { self.hamMenuShadowView.alpha = 0.6 }
            }
            else {
                self.animateSideMenu(targetPosition: self.revealHamMenuOnTop ? (-self.hamburgerWidth - self.paddingForRotation) : 0) { _ in
                    self.isExpanded = false
                }
                // Animate Shadow (Fade Out)
                UIView.animate(withDuration: 0.5) { self.hamMenuShadowView.alpha = 0.0 }
            }
        }

        func animateSideMenu(targetPosition: CGFloat, completion: @escaping (Bool) -> ()) {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .layoutSubviews, animations: {
                if self.revealHamMenuOnTop {
                    self.hamMenuTrailingConstraint.constant = targetPosition
                    self.view.layoutIfNeeded()
                }
                else {
                    self.view.subviews[1].frame.origin.x = targetPosition
                }
            }, completion: completion)
        }
    
}
