//
//  FeedViewController.swift
//  Parstagram
//
//  Created by Micaella Morales on 3/5/19.
//  Copyright © 2019 Micaella Morales. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var posts = [PFObject]()
    var postLimit: Int!
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        loadPosts()
        // Do any additional setup after loading the view.
        refreshControl.addTarget(self, action: #selector(loadPosts), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let titleImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 5))
        titleImageView.contentMode = .scaleAspectFit
        titleImageView.clipsToBounds = true
        titleImageView.center = (navigationController?.navigationBar.center)!
        
        let image = UIImage(named: "Instagram_logo")
        titleImageView.image = image
        
        navigationItem.titleView = titleImageView
    }
    
    @objc func loadPosts() {
        postLimit = 5
        let query = PFQuery(className:"Posts")
        query.includeKey("author")
        query.limit = postLimit
        query.addDescendingOrder("createdAt")
        query.findObjectsInBackground { (posts, error) in
            if posts != nil {
                self.posts = posts!
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    func loadMorePosts() {
        self.posts.removeAll()
        postLimit += 5
        let query = PFQuery(className:"Posts")
        query.includeKey("author")
        query.limit = postLimit
        query.addDescendingOrder("createdAt")
        query.findObjectsInBackground { (posts, error) in
            if posts != nil {
                self.posts = posts!
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func onLogout(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.row + 1 == posts.count) {
            loadMorePosts()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
        let post = posts[indexPath.row]
        
        let user = post["author"] as! PFUser
        cell.usernameLabel.text = user.username
        cell.usernameOtherLabel.text = user.username
        
        cell.captionLabel.text = post["caption"] as? String
        
        let imageFile = post["image"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        
        cell.photoView.af_setImage(withURL: url)
        
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
