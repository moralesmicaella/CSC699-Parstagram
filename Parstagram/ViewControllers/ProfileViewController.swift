//
//  ProfileViewController.swift
//  Parstagram
//
//  Created by Micaella Morales on 3/10/19.
//  Copyright © 2019 Micaella Morales. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage

class ProfileViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var userPosts = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        
        let currUser = PFUser.current()
        let query = PFQuery(className:"Posts")
        query.includeKey("author")
        query.limit = 20
        query.addDescendingOrder("createdAt")
        query.findObjectsInBackground { (posts, error) in
            if posts != nil {
                for post in posts! {
                    let author = post["author"] as! PFUser
                    if (author.objectId! == currUser!.objectId) {
                        self.userPosts.append(post)
                    }
                }
                print("Retrieved user posts")
                self.collectionView.reloadData()
            }
            else {
                print("Error\(String(describing: error))")
            }
        }
        navigationItem.title = currUser?.username
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        
        let width = (view.frame.size.width - layout.minimumInteritemSpacing*3) / 3
        layout.itemSize = CGSize(width: width, height: width * 3/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userPosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserPostCell", for: indexPath) as! UserPostCell
        let post = userPosts[indexPath.row]
        let imageFile = post["image"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        
        cell.userPhotoView.af_setImage(withURL: url)
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
