//
//  UserCommentsCell.swift
//  Parstagram
//
//  Created by Micaella Morales on 3/16/19.
//  Copyright © 2019 Micaella Morales. All rights reserved.
//

import UIKit

class UserCommentsCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
