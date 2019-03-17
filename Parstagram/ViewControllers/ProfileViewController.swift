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

class ProfileViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    
    var userPosts = [PFObject]()
    let currUser = PFUser.current()
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        //loads the profile image of the user
        let imageFile = currUser!["profileImage"] as? PFFileObject ?? nil
        if imageFile != nil {
            let urlString = imageFile!.url!
            let url = URL(string: urlString)!
            profileImageView.af_setImage(withURL: url)
        }
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        
        nameLabel.text = currUser!["name"] as? String ?? " "
        bioLabel.text = currUser!["bio"] as? String ?? " "
        
        loadUserPosts()
        navigationItem.title = currUser?.username
        
        refreshControl.addTarget(self, action: #selector(loadUserPosts), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        
        //sets the layout of the collection view
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        
        let width = (view.frame.size.width - layout.minimumInteritemSpacing*3) / 3
        layout.itemSize = CGSize(width: width, height: width)
    }
    
    @objc func loadUserPosts() {
        let query = PFQuery(className:"Posts")
        query.includeKeys(["author", "comments", "comments.author"])
        query.limit = 30
        query.addDescendingOrder("createdAt")
        userPosts.removeAll()
        query.findObjectsInBackground { (posts, error) in
            if posts != nil {
                for post in posts! {
                    let author = post["author"] as! PFUser
                    if (author.objectId! == self.currUser!.objectId) {
                        self.userPosts.append(post)
                    }
                }
                print("Retrieved user posts")
                self.collectionView.reloadData()
                self.refreshControl.endRefreshing()
            }
            else {
                print("Error\(String(describing: error))")
            }
        }
    }
    
    @IBAction func changeProfileImage(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        }
        else {
            picker.sourceType = .photoLibrary
        }
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        
        let size = CGSize(width: 300, height: 300)
        let scaledImage = image.af_imageAspectScaled(toFill: size)
        
        profileImageView.image = scaledImage
        
        let imageData = profileImageView.image!.pngData()
        let file = PFFileObject(data: imageData!)
        
        currUser!["profileImage"] = file
        
        currUser!.saveInBackground { (success, error) in
            if success {
                print("saved!")
            }
            else {
                print("error!")
            }
        }
        
        dismiss(animated: true, completion: nil)
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        collectionView.delegate = self
        
        //Find the selected post
        let cell = sender as! UICollectionViewCell
        let indexPath = collectionView.indexPath(for: cell)!
        let post = userPosts[indexPath.row]
        
        //Pass the selected post to the details view controller
        let detailsGridViewController = segue.destination as! PostDetailsViewController
        detailsGridViewController.post = post
    
    }
    

}
