//
//  CommentsViewController.swift
//  Parstagram
//
//  Created by Micaella Morales on 3/16/19.
//  Copyright © 2019 Micaella Morales. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage

class CommentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var comments = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        navigationItem.title = "Comments"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCommentsCell") as! UserCommentsCell
        let comment = comments[indexPath.row]
        
        cell.commentLabel.text = comment["text"] as? String
        
        let user = comment["author"] as! PFUser
        cell.usernameLabel.text = user.username
        
        let userImageFile = user["profileImage"] as? PFFileObject ?? nil
        if userImageFile != nil {
            let userUrlString = userImageFile!.url!
            let userUrl = URL(string: userUrlString)!
            
            cell.profileImageView.af_setImage(withURL: userUrl)
            cell.profileImageView.layer.cornerRadius = cell.profileImageView.frame.height/2
            cell.profileImageView.layer.masksToBounds = true
        }
        else {
            cell.profileImageView.image = UIImage(named: "default-profile")
        } 
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
