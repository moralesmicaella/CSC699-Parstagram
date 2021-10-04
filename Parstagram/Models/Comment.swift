//
//  Comment.swift
//  Parstagram
//
//  Created by Micaella Morales on 3/16/21.
//

import Foundation
import Parse

class Comment {
    
    var user: PFUser
    var text: String
    var profileImage: UIImage
    
    init(_ comment: PFObject) {
        user = comment["user"] as! PFUser
        text = comment["text"] as! String
        profileImage = Image.getImageFromFile(user["profile_photo"] as! PFFileObject)
    }
    
}
