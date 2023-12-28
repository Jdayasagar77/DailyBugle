//
//  HamburgerVC.swift
//  Daily Bugle
//
//  Created by J Dayasagar on 13/04/23.
//

import UIKit
import FirebaseFirestore

class HamburgerVC: BaseClass {

    var userConfig: UserConfigurationDelegate?
    var newsDelegate: GetNews?
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
        HamModel(icon: UIImage(named: "Ham1") ?? UIImage(), title: .sports),        HamModel(icon: UIImage(named: "Ham1") ?? UIImage(), title: .saved)
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
                // TableView
               self.hamTableView.delegate = self
               self.hamTableView.dataSource = self
               self.hamTableView.backgroundColor = #colorLiteral(red: 0.737254902, green: 0.1294117647, blue: 0.2941176471, alpha: 1)
               self.hamTableView.separatorStyle = .none
               // Set Highlighted Cell
               DispatchQueue.main.async {
                   let defaultRow = IndexPath(row: self.defaultHighlightedCell, section: 0)
                   self.hamTableView.selectRow(at: defaultRow, animated: false, scrollPosition: .none)
               }

               // Register TableView Cell
                self.hamTableView.register(UINib(nibName: "HamburgerCell", bundle: nil), forCellReuseIdentifier: "HamburgerCell")

               // Update TableView with the data
                self.hamTableView.reloadData()
                self.hamTableView.estimatedRowHeight = 300
        print(self.userConfig!.userUID)
        db.collection("Users").document(userConfig!.userUID ?? "").getDocument { doc, error in
            let userData = doc?.data()
            self.userNameLabel.text = userData?["name"] as? String ?? ""
            self.emailLabel.text = userData?["email"] as? String ?? ""
            self.profileImage.image = UIImage(data: Data( (userData?["profilePic"] as? String ?? "").utf8))
        }
        
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menu.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HamburgerCell", for: indexPath) as? HamburgerCell else { fatalError("xib doesn't exist") }

              cell.iconImageView.image = self.menu[indexPath.row].icon
            cell.titleLabel.text = self.menu[indexPath.row].title.categoryName

              // Highlighted color
              let myCustomSelectionColorView = UIView()
              myCustomSelectionColorView.backgroundColor = #colorLiteral(red: 0.6196078431, green: 0.1098039216, blue: 0.2509803922, alpha: 1)
              cell.selectedBackgroundView = myCustomSelectionColorView
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
