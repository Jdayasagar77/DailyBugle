//
//  SubmitButtonCell.swift
//  Daily Bugle
//
//  Created by J Dayasagar on 20/12/22.
//

import UIKit

class SubmitButtonCell: UITableViewCell {
    @IBOutlet weak var SubmitButtonCell: UIButton!
    var actionHandler: (()->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func submitAction(_ sender: Any) {
        actionHandler?()
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

