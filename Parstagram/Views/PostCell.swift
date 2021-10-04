//
//  PostCell.swift
//  Parstagram
//
//  Created by Micaella Morales on 3/10/21.
//

import UIKit
import Parse
class PostCell: UITableViewCell {
    
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var postImageView: UIImageView!
    @IBOutlet var captionLabel: UILabel!
    
    var post: Post! {
        didSet {
            profileImageView.image = post.profileImage
            postImageView.image = post.postImage
            usernameLabel.text = post.user.username
            
            let caption = NSString(string: post.user.username! + " " + post.caption)
            let usernameRange = caption.range(of: post.user.username!)
            let attributedCaption = NSMutableAttributedString(string: caption as String)
            attributedCaption.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Helvetica Neue Medium", size: 15)!, range: usernameRange)
            captionLabel.attributedText = attributedCaption
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        let text = NSString(stringLiteral: "hello user")
//        let range = text.range(of: "hello")
//        let attribute = NSMutableAttributedString(string: text as String)
//        attribute.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Helvetica Neue Medium", size: 15)!, range: range)
//        captionLabel.attributedText = attribute
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
