//
//  NewsFeedCell.swift
//  Daily Bugle
//
//  Created by J Dayasagar on 08/01/23.
//

import UIKit

class NewsFeedCell: UITableViewCell {

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var articlePublished: UILabel!
    @IBOutlet weak var articleTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
