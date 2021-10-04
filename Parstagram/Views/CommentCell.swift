//
//  CommentCell.swift
//  Parstagram
//
//  Created by Micaella Morales on 3/16/21.
//

import UIKit

class CommentCell: UITableViewCell {
    
    @IBOutlet var commentLabel: UILabel!
    @IBOutlet var profileImageView: UIImageView!
    
    var comment: Comment! {
        didSet {
            let comment = NSString(string: self.comment.user.username! + " " + self.comment.text)
            let usernameRange = comment.range(of: self.comment.user.username!)
            let attributedCaption = NSMutableAttributedString(string: comment as String)
            attributedCaption.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Helvetica Neue Medium", size: 15)!, range: usernameRange)
            commentLabel.attributedText = attributedCaption
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
