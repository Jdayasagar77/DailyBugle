//
//  MainVC.swift
//  Daily Bugle
//
//  Created by J Dayasagar on 03/12/22.
//

import UIKit



class MainVC: BaseClass, UserConfigurationDelegate  {
    
    let myHamVC = HamburgerVC.init(nibName: "HamburgerVC", bundle: nil)
    
    var userUID: String? {
        debugPrint(userUIDDelegate?.userUID as Any)
        //if Utility.shared.isUserLogin(){}
        //You need to persist uid also in userdefaults
        return userUIDDelegate == nil ? UserDefaults.standard.string(forKey: DefaultKeys.userUID) : userUIDDelegate?.userUID
    }
    
    var userUIDDelegate: UserConfigurationDelegate?
    
    var myCategory: Category? {
        didSet {
            print(self.myCategory?.rawValue as Any)
            self.viewDidLoad()
        }
    }
    
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
        myHamVC.userConfig = self
        navigationController?.pushViewController(myHamVC, animated: true)
    }
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
               spinner.startAnimating()
        self.view.addSubview(spinner)

               spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
               spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
                self.mainTable.register(UINib(nibName: "NewsFeedCell", bundle: nil), forCellReuseIdentifier: "NewsFeedCell")
        self.mainTable.delegate = self
        self.mainTable.dataSource = self
        self.mainTable.estimatedRowHeight = 300
        print(myCategory as Any)
            Utility.shared.newsConnection.fetchNews(category: myCategory ?? .general) { [weak self] result in
                DispatchQueue.main.async {
                    self?.isLoading = false
                    switch result {
                    case .failure(let error):
                        self?.errorMessage = error.localizedDescription
                        print(error)
                    case .success(let news):
                        print("--- success with \(news.count)")
                        let filteredArticles = news.filter { article in
                            // Check if any of the properties in the article is nil
                            return article.author != nil &&
                            article.title != nil &&
                            article.description != nil &&
                            article.url != nil &&
                            article.urlToImage != nil &&
                            article.publishedAt != nil
                        }
                        self?.myArticles = filteredArticles
                        self?.mainTable.reloadData()
                        spinner.stopAnimating()
                    }
                }
            }
       
       
    } //ViewDidLoad
     
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
        cell?.handler = {
            
          //  debugPrint(self.myHamVC.userConfig?.userUID as Any)
         //   print(self.myArticles?[indexPath.row] as Any)
            let newArticle = Article(source: self.myArticles![indexPath.row].source, author: self.myArticles![indexPath.row].author, title: self.myArticles![indexPath.row].title, description: self.myArticles![indexPath.row].description, url: self.myArticles![indexPath.row].url, urlToImage: self.myArticles![indexPath.row].urlToImage, publishedAt: self.myArticles![indexPath.row].publishedAt, content: self.myArticles![indexPath.row].content)
            
            Utility.shared.db.collection("Users").document(self.myHamVC.userConfig!.userUID ?? "").collection("savedArticles").document("\(newArticle.title!)").setData([
                "author":newArticle.author!,
                "title":newArticle.title!,
                "description":newArticle.description!,
                "url":newArticle.url!,
                "urlToImage":newArticle.urlToImage!,
                "publishedAt":newArticle.publishedAt!
            ])
   
            Utility.shared.db.collection("Users").document(self.myHamVC.userConfig!.userUID ?? "").collection("savedArticles").getDocuments { doc, error in
                
               let isThere = doc?.documents.contains(where: { mydoc in
                   mydoc.documentID == newArticle.title
                })
                
                debugPrint(isThere as Any)
                debugPrint(doc?.count as Any)
                debugPrint(doc?.description as Any)
                debugPrint(doc?.documents.first as Any)
                debugPrint(doc?.documents.first?.documentID as Any)

            }
            
            /*    .addDocument(data: [
                "author":newArticle.author!,
                "title":newArticle.title!,
                "description":newArticle.description!,
                "url":newArticle.url!,
                "urlToImage":newArticle.urlToImage!,
                "publishedAt":newArticle.publishedAt!,
                "content": newArticle.content!,
            ]) { error in
                debugPrint(error as Any)
            }
             */
            
                /*
                .setData([
                "savedArticles": Article(source: self.myArticles![indexPath.row].source, author: self.myArticles![indexPath.row].author, title: self.myArticles![indexPath.row].title, description: self.myArticles![indexPath.row].description, url: self.myArticles![indexPath.row].url, urlToImage: self.myArticles![indexPath.row].urlToImage, publishedAt: self.myArticles![indexPath.row].publishedAt, content: self.myArticles![indexPath.row].content)
            ], merge: true)
            */
            
           //
        }
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return UITableView.automaticDimension
    }
    
}

@available(iOS 17, *)
#Preview(traits: .portrait, body: {
    MainVC()
})

