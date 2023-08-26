//
//  MainVC.swift
//  Daily Bugle
//
//  Created by J Dayasagar on 03/12/22.
//

import UIKit

class MainVC: UIViewController {
    
    let myHamVC = HamburgerVC.init(nibName: "HamburgerVC", bundle: nil)
    var myCategory: Category?
    {
        didSet{
          //  UserDefaults.standard.setValue(myCategory, forKey: "category")
            print(self.myCategory?.rawValue as Any)
            self.viewDidLoad()
        }
    }
    
    let newsConnection = NewsAPIBackend.shared
    @IBOutlet weak var mainTable: UITableView!
    @IBOutlet var hamburgerBtn: UIBarButtonItem!
    var isLoading: Bool = true
    var errorMessage: String? = nil
    var myArticles: [Article]?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      navigationController?.setNavigationBarHidden(true, animated: animated)
     }

    
    @IBAction func hamBurgerBtnAction(_ sender: UIBarButtonItem) {
        myHamVC.newsDelegate = self
        navigationController?.pushViewController(myHamVC, animated: true)
        //present(myHamVC, animated: true)
    }
    
  
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.mainTable.register(UINib(nibName: "NewsFeedCell", bundle: nil), forCellReuseIdentifier: "NewsFeedCell")
        self.mainTable.delegate = self
        self.mainTable.dataSource = self
        self.mainTable.estimatedRowHeight = 300
        print(myCategory as Any)
        newsConnection.fetchNews(category: myCategory ?? .general) { [weak self] result in DispatchQueue.main.async {
            self?.isLoading = false
            switch result {
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    print(error)
                case .success(let news):
                    print("--- success with \(news.count)")
                    self?.myArticles = news
                    self?.mainTable.reloadData()
                }
            }
        }
    }
     
}






extension MainVC : UITableViewDelegate,UITableViewDataSource, GetNews {
    
    func getNews(category: Category) {
        self.myCategory = category
    }
    

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
       
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
}




