//
//  UserListTableViewCell.swift
//  WhatsappClone
//
//  Created by Mayur on 16/04/17.
//  Copyright © 2017 mayur. All rights reserved.
//

import UIKit

class UserListTableViewCell: UITableViewCell {

    @IBOutlet var userProfileIV: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
  
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
