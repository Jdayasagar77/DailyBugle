//
//  HamburgerVC.swift
//  Daily Bugle
//
//  Created by J Dayasagar on 03/12/22.
//

import UIKit

class HamburgerVC: UIViewController {
    
    @IBOutlet var headerImageView: UIImageView!
    @IBOutlet var hamburgerTableView: UITableView!
    @IBOutlet var footerLabel: UILabel!

    var defaultHighlightedCell: Int = 0

    var delegate: HamburgerVCDelegate?

        var menu: [HamburgerModel] = [
        HamburgerModel(icon: UIImage(systemName: "house.fill")!, title: "Home"),
        HamburgerModel(icon: UIImage(systemName: "music.note")!, title: "Music"),
        HamburgerModel(icon: UIImage(systemName: "film.fill")!, title: "Movies"),
        HamburgerModel(icon: UIImage(systemName: "book.fill")!, title: "Books"),
        HamburgerModel(icon: UIImage(systemName: "person.fill")!, title: "Profile"),
        HamburgerModel(icon: UIImage(systemName: "slider.horizontal.3")!, title: "Settings"),
        HamburgerModel(icon: UIImage(systemName: "hand.thumbsup.fill")!, title: "Like us on facebook")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        // TableView
        self.hamburgerTableView.delegate = self
        self.hamburgerTableView.dataSource = self
        self.hamburgerTableView.backgroundColor = #colorLiteral(red: 0.737254902, green: 0.1294117647, blue: 0.2941176471, alpha: 1)
        self.hamburgerTableView.separatorStyle = .none
        self.headerImageView.image = UIImage(named: "bugle3")
        // Set Highlighted Cell
        DispatchQueue.main.async {
            let defaultRow = IndexPath(row: self.defaultHighlightedCell, section: 0)
            self.hamburgerTableView.selectRow(at: defaultRow, animated: false, scrollPosition: .none)
        }

        // Footer
        self.footerLabel.textColor = UIColor.black
        self.footerLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        self.footerLabel.text = "Developed by Spider77"

        // Register TableView Cell
        self.hamburgerTableView.register(UINib(nibName: "HamburgerCell", bundle: nil), forCellReuseIdentifier: "HamburgerCell")

        // Update TableView with the data
        self.hamburgerTableView.reloadData()
    }
}

// MARK: - UITableViewDelegate

extension HamburgerVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

// MARK: - UITableViewDataSource

extension HamburgerVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menu.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HamburgerCell", for: indexPath) as? HamburgerCell else { fatalError("xib doesn't exist") }

        cell.iconImageView.image = self.menu[indexPath.row].icon
        cell.titleLabel.text = self.menu[indexPath.row].title

        // Highlighted color
        let myCustomSelectionColorView = UIView()
        myCustomSelectionColorView.backgroundColor = #colorLiteral(red: 0.6196078431, green: 0.1098039216, blue: 0.2509803922, alpha: 1)
        cell.selectedBackgroundView = myCustomSelectionColorView
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.delegate?.selectedCell(indexPath.row)

        // Remove highlighted color when you press the 'Profile' and 'Like us on facebook' cell
        if indexPath.row == 4 || indexPath.row == 6 {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}


protocol HamburgerVCDelegate {
    func selectedCell(_ row: Int)
}
