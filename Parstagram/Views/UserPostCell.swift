//
//  UserPostCell.swift
//  Parstagram
//
//  Created by Micaella Morales on 3/10/21.
//

import UIKit

class UserPostCell: UICollectionViewCell {
    
    @IBOutlet var postImageView: UIImageView!
    
    var post: Post! {
        didSet {
            postImageView.image = post.postImage
        }
    }
    
}
