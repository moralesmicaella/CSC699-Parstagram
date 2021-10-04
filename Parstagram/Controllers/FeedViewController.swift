//
//  HomeViewController.swift
//  Parstagram
//
//  Created by Micaella Morales on 3/7/21.
//

import UIKit
import Parse
import AlamofireImage
import YPImagePicker
import MessageInputBar

class FeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MessageInputBarDelegate {
    
    @IBOutlet var postTableView: UITableView!
    
    var posts = [Post]()
    var selectedPost: PFObject!
    var postsQueryLimit = 10
    
    var config: YPImagePickerConfiguration!
    var imagePicker: YPImagePicker!
    var postViewController: SharePostViewController!
    var commentBar: MessageInputBar!
    var showCommentBar: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let instagramLogo = UIButton(type: .custom)
        instagramLogo.setImage(UIImage(named: "instagram_logo"), for: .normal)
        
        let leftBarButtonItem = UIBarButtonItem(customView: instagramLogo)
        leftBarButtonItem.customView?.widthAnchor.constraint(equalToConstant: 120).isActive = true
        navigationItem.leftBarButtonItem = leftBarButtonItem
        
        postTableView.dataSource = self
        postTableView.delegate = self
        
        commentBar = MessageInputBar()
        commentBar.inputTextView.placeholderLabel.text = "Add a comment..."
        commentBar.sendButton.setTitle("Post", for: .normal)
        commentBar.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        config = YPImagePickerConfiguration()
        config.startOnScreen = YPPickerScreen.library
        config.shouldSaveNewPicturesToAlbum = false
        postViewController = storyboard?.instantiateViewController(identifier: "PostViewController")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadPosts()
    }
    
    override var inputAccessoryView: UIView? {
        return commentBar
    }
    
    override var canBecomeFirstResponder: Bool {
        return showCommentBar
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        commentBar.inputTextView.text = nil
        showCommentBar = false
        becomeFirstResponder()
        commentBar.inputTextView.resignFirstResponder()
    }
    
    @IBAction func onCameraButton(_ sender: Any) {
        imagePicker = YPImagePicker(configuration: config)
        imagePicker.didFinishPicking { (mediaItems, cancelled) in
            if cancelled {
                self.dismiss(animated: true, completion: nil)
            } else {
                if let photo = mediaItems.singlePhoto {
                    self.postViewController.image = photo.image
                    self.imagePicker.pushViewController(self.postViewController, animated: true)
                }
            }
        }
        present(imagePicker, animated: true, completion: nil)
    }
    
    func loadPosts() {
        Post.loadPosts(postsQueryLimit, constraints: nil) { (posts) in
            self.posts.removeAll()
            self.posts = posts
            self.postTableView.reloadData()
        }
    }
    
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        let comment = PFObject(className: "Comments")
        
        comment["user"] = PFUser.current()
        comment["text"] = text
        comment["post"] = selectedPost
        
        selectedPost.add(comment, forKey: "comments")
        selectedPost.saveInBackground { (success, error) in
            if success {
                self.loadPosts()
                print("Comments saved!")
            } else {
                print("Error: \(String(describing: error?.localizedDescription))")
            }
        }
        
        commentBar.inputTextView.text = nil
        showCommentBar = false
        becomeFirstResponder()
        commentBar.inputTextView.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let post = posts[section]
        
        return post.comments.count + 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.section]
        
        if indexPath.row == 0 {
            let cell = postTableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
            cell.post = post
            
            return cell
        } else if indexPath.row <= post.comments.count {
            let cell = postTableView.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentCell
            cell.comment = post.comments[indexPath.row - 1]
            
            return cell
        } else {
            let cell = postTableView.dequeueReusableCell(withIdentifier: "AddCommentCell")!
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = posts[indexPath.section]
        
        if indexPath.row == post.comments.count + 1 {
            showCommentBar = true
            becomeFirstResponder()
            commentBar.inputTextView.becomeFirstResponder()
        }
        
        selectedPost = post.object
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

