//
//  HamburgerVC.swift
//  Daily Bugle
//
//  Created by J Dayasagar on 13/04/23.
//

import UIKit
import FirebaseFirestore

class HamburgerVC: BaseClass {
    
    private let loginButton = UIButton()
    var userConfig: UserConfigurationDelegate?
    var newsDelegate: GetNews?
    var savedDelegate: SavedArticles?
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var hamTableView: UITableView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    var defaultHighlightedCell: Int = 0
    
    
    var menu: [HamModel] = [
        //        HamModel(icon: UIImage(systemName: "bookmark.fill")!, title: "Saved")
        HamModel(icon: UIImage(named: "Ham1") ?? UIImage(), title: .technology),
        HamModel(icon: UIImage(named: "Ham2") ?? UIImage(), title: .business),
        HamModel(icon: UIImage(named: "Ham3") ?? UIImage(), title: .entertainment),
        HamModel(icon: UIImage(named: "Ham4") ?? UIImage(), title: .science),
        HamModel(icon: UIImage(named: "Ham1") ?? UIImage(), title: .health),
        HamModel(icon: UIImage(named: "Ham1") ?? UIImage(), title: .sports),
        
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // TableView
        self.hamTableView.delegate = self
        self.hamTableView.dataSource = self
        self.hamTableView.separatorStyle = .none
        // Set Highlighted Cell
        //               DispatchQueue.main.async {
        //                   let defaultRow = IndexPath(row: self.defaultHighlightedCell, section: 0)
        //                   self.hamTableView.selectRow(at: defaultRow, animated: false, scrollPosition: .none)
        //               }
        
        // Register TableView Cell
        self.hamTableView.register(UINib(nibName: "HamburgerCell", bundle: nil), forCellReuseIdentifier: "HamburgerCell")
        
        // Update TableView with the data
        self.hamTableView.reloadData()
        self.hamTableView.estimatedRowHeight = 300
        self.hamTableView.layer.cornerRadius = 20
        self.hamTableView.clipsToBounds = true
        print(self.userConfig!.userUID as Any)
        Utility.shared.db.collection("Users").document(userConfig!.userUID ?? "").getDocument { doc, error in
            let userData = doc?.data()
            self.userNameLabel.text = userData?["name"] as? String ?? ""
            self.emailLabel.text = userData?["email"] as? String ?? ""
            debugPrint(userData?["profilePic"] as? String ?? "")
            let dataDecoded:Data = Data(base64Encoded: userData?["profilePic"] as? String ?? "", options: .ignoreUnknownCharacters)!
            self.profileImage.image =  UIImage(data: dataDecoded as Data) ?? UIImage(named: "dj")
            let footerView = UIView()
            footerView.frame.size.height = 100
            // login button customization
            self.loginButton.setTitle("Sign Out", for: .normal)
            self.loginButton.setTitleColor(.white, for: .normal)
            self.loginButton.layer.cornerRadius = 10
            self.loginButton.layer.masksToBounds = true
            self.loginButton.backgroundColor = .darkGray.withAlphaComponent(0.5)
            self.loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
            self.loginButton.addTarget(self, action: #selector(self.handleLoginButtonTapped), for: .touchUpInside)
            
            // adding the constraints to login button
            footerView.addSubview( self.loginButton)
            self.loginButton.translatesAutoresizingMaskIntoConstraints = false
            self.loginButton.centerYAnchor.constraint(equalTo: footerView.centerYAnchor).isActive = true
            self.loginButton.centerXAnchor.constraint(equalTo: footerView.centerXAnchor).isActive = true
            self.loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
            self.loginButton.widthAnchor.constraint(equalToConstant: 280).isActive = true
            self.hamTableView.tableFooterView = footerView
            
        }
        
    }
    
    @objc private func handleLoginButtonTapped() {
        print("login button tapped...")
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     segue.destination
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension HamburgerVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menu.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HamburgerCell", for: indexPath) as? HamburgerCell else { fatalError("xib doesn't exist") }
        
        cell.iconImageView.image = self.menu[indexPath.row].icon
        cell.titleLabel.text = self.menu[indexPath.row].title.categoryName
        cell.hamburgerCustomView.layer.cornerRadius = 20
        cell.hamburgerCustomView.clipsToBounds = true
        
        cell.selectionStyle = .gray
        
        
        //     cell.backgroundColor = .magenta
        
        // Highlighted color
        //              let myCustomSelectionColorView = UIView()
        //              myCustomSelectionColorView.backgroundColor = #colorLiteral(red: 0.6196078431, green: 0.1098039216, blue: 0.2509803922, alpha: 1)
        //              cell.selectedBackgroundView = myCustomSelectionColorView
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        DispatchQueue.main.async {
        if self.newsDelegate != nil {
            self.newsDelegate?.getNews(category:  self.menu[indexPath.row].title )
            navigationController?.popViewController(animated: true)
        } else {
            print("Delegate is nil")
        }
        //  }
    }
}



