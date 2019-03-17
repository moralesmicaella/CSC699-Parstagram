//
//  PostDetailsViewController.swift
//  Parstagram
//
//  Created by Micaella Morales on 3/13/19.
//  Copyright © 2019 Micaella Morales. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage

class PostDetailsViewController: UIViewController {

    var post: PFObject?
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var usernameOtherLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var viewCommentsLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let user = post!["author"] as! PFUser
        usernameLabel.text = user.username
        usernameOtherLabel.text = user.username
        
        captionLabel.text = post!["caption"] as? String
        
        let imageFile = post!["image"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        
        photoView.af_setImage(withURL: url)
        
        let userImageFile = user["profileImage"] as? PFFileObject ?? nil
        if userImageFile != nil {
            let userUrlString = userImageFile!.url!
            let userUrl = URL(string: userUrlString)!
            
            profileImageView.af_setImage(withURL: userUrl)
            profileImageView.layer.cornerRadius = profileImageView.frame.height/2
            profileImageView.layer.masksToBounds = true
        }
        else {
            profileImageView.image = UIImage(named: "default-profile")
        }
        
        let comments = (post!["comments"] as? [PFObject]) ?? []
        if comments.count > 0 {
            if comments.count == 1 {
                viewCommentsLabel.text = "View 1 comment"
            }
            else {
                viewCommentsLabel.text = "View all " + String(comments.count) + " comments"
            }
        }
        else {
            viewCommentsLabel.text = " "
        }
    }
    
    
    @IBAction func viewComments(_ sender: Any) {
        self.performSegue(withIdentifier: "commentsSegue", sender: nil)
        
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "commentsSegue" {
            let comments = post!["comments"] as? [PFObject]
            let commentsViewController = segue.destination as! CommentsViewController
            commentsViewController.comments = comments!
        }
    }
 
}
