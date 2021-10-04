//
//  PostViewController.swift
//  Parstagram
//
//  Created by Micaella Morales on 10/3/21.
//

import UIKit
import Parse

class PostViewController: UIViewController {
    
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var postImageView: UIImageView!
    @IBOutlet var captionLabel: UILabel!
    @IBOutlet var viewCommentsLabel: UILabel!
    
    var post: Post!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        profileImageView.image = post.profileImage
        postImageView.image = post.postImage
        usernameLabel.text = post.user.username
        
        let caption = NSString(string: post.user.username! + " " + post.caption)
        let usernameRange = caption.range(of: post.user.username!)
        let attributedCaption = NSMutableAttributedString(string: caption as String)
        attributedCaption.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Helvetica Neue Medium", size: 15)!, range: usernameRange)
        captionLabel.attributedText = attributedCaption
        
        let comments = post.comments
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
    
    @IBAction func onBackButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func onViewComments(_ sender: Any) {
        performSegue(withIdentifier: "commentsSegue", sender: self)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        let controller = segue.destination as! CommentsViewController
        
        // Pass the selected object to the new view controller.
        controller.post = post
    }

}
