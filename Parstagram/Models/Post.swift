//
//  Post.swift
//  Parstagram
//
//  Created by Micaella Morales on 3/10/21.
//

import Foundation
import Parse

class Post {
    
    var object: PFObject
    var user: PFUser
    var profileImage: UIImage
    var postImage: UIImage
    var caption: String
    var comments: [Comment]
    
    init(_ post: PFObject) {
        object = post
        user = post["user"] as! PFUser
        profileImage = Image.getImageFromFile(user["profile_photo"] as! PFFileObject)
        postImage = Image.getImageFromFile(post["image"] as! PFFileObject)
        caption = post["caption"] as! String
        comments = [Comment]()
        if let postComments = post["comments"] as? [PFObject] {
            for comment in postComments {
                comments.append(Comment(comment))
            }
        }
    }
    
    static func loadPosts(_ limit: Int, constraints: [String: Any]?, completion: @escaping ([Post]) -> Void) {
        let query = PFQuery(className: "Posts")
        query.limit = limit
        query.includeKeys(["user", "comments", "comments.user"])
        query.order(byDescending: "createdAt")
        
        var posts = [Post]()
        
        if constraints != nil {
            constraints?.forEach { (key, value) in
                query.whereKey(key, equalTo: value)
            }
        }
        
        query.findObjectsInBackground { (results, error) in
            if results != nil {
                results!.forEach { (result) in
                    posts.append(Post(result))
                }
                completion(posts)
            } else {
                print("Error: \(String(describing: error?.localizedDescription))")
            }
        }
    }
    
    
    
}

