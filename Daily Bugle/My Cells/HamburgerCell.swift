//
//  HamburgerCell.swift
//  Daily Bugle
//
//  Created by J Dayasagar on 03/12/22.
//

import UIKit

class HamburgerCell: UITableViewCell {
    

    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
 
        // Background
        self.backgroundColor = .clear
        
        // Icon
        self.iconImageView.tintColor = .white
        
        // Title
        self.titleLabel.textColor = .white
    }


override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
