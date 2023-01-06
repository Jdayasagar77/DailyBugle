//
//  ProfilePicCell.swift
//  Daily Bugle
//
//  Created by J Dayasagar
//

import UIKit

class ProfilePicCell: UITableViewCell {
    //MARK: - Outlates
    /// Profile image
    @IBOutlet weak var imgProfile: UIImageView!
    /// Button Object
    @IBOutlet weak var btnSelectImage: UIButton!
    
    //MARK: - Outlates
    var handler: (() -> ())?
    
    //MARK: - Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    /// Select profile piic action
    /// - Parameter sender: button object
    @IBAction func selectProfilePicAction(_ sender: Any) {
        handler?()
    }
    func updateUI(image: UIImage?) {
        guard let img = image else {
            return
        }
        self.imgProfile.image = img
    }
        override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        self.selectionStyle = .none
    }
   
}
