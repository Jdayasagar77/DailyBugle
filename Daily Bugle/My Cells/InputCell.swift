//
//  InputCell.swift
//  Daily Bugle
//
//  Created by J Dayasagar
//

import UIKit

class InputCell: UITableViewCell {
    
    //MARK: - Outlates
    /// Use to input data
    @IBOutlet weak var inputText: UITextField!
    
    //MARK: - Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
        
        // Configure the view for the selected state
    }
    
}
    
