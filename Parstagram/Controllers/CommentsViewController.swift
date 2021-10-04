//
//  CommentsViewController.swift
//  Parstagram
//
//  Created by Micaella Morales on 10/3/21.
//

import UIKit

class CommentsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var captionLabel: UILabel!
    @IBOutlet var commentsTableView: UITableView!
    
    var post: Post!
    var comments: [Comment]!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        profileImageView.image = post.profileImage
        
        let caption = NSString(string: post.user.username! + " " + post.caption)
        let usernameRange = caption.range(of: post.user.username!)
        let attributedCaption = NSMutableAttributedString(string: caption as String)
        attributedCaption.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Helvetica Neue Medium", size: 15)!, range: usernameRange)
        captionLabel.attributedText = attributedCaption
        
        commentsTableView.dataSource = self
        commentsTableView.delegate = self
        
        comments = post.comments
    }
    
    @IBAction func onBackButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = commentsTableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
        
        let comment = comments[indexPath.row]
        cell.comment = comment
        cell.profileImageView.image = comment.profileImage
        
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
