//
//  SavedVC.swift
//  Daily Bugle
//
//  Created by J Dayasagar on 08/11/23.
//

import UIKit

class SavedVC: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var savedTableView: UITableView!
    
    private  var myArticles: [Article]? {
        didSet {
            self.savedTableView.reloadData()
        }
    }
    var userUID: String?
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.savedTableView.register(UINib(nibName: "NewsFeedCell", bundle: nil), forCellReuseIdentifier: "NewsFeedCell")
        self.savedTableView.delegate = self
        self.savedTableView.dataSource = self
        self.savedTableView.estimatedRowHeight = 300
        self.navigationController?.setNavigationBarHidden(false, animated: true)

        
        Utility.shared.db.collection("Users").document(self.userUID ?? "").collection("savedArticles").getDocuments { doc, error in
            
            let yoArticles = doc?.documents.map({ myDoc in
                return Article(source: nil, author: myDoc["author"] as? String, title: myDoc["title"] as? String, description: myDoc["description"] as? String, url: myDoc["url"] as? String, urlToImage: myDoc["urlToImage"] as? String, publishedAt: myDoc["publishedAt"] as? String, content: myDoc["content"] as? String)
            })
            self.myArticles = yoArticles
           
            debugPrint("The saved article count is: ",self.myArticles?.count as Any)
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}


extension SavedVC {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.myArticles?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.savedTableView.dequeueReusableCell(withIdentifier: "NewsFeedCell") as? NewsFeedCell
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
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
