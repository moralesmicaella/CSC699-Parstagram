//
//  ProfileViewController.swift
//  Parstagram
//
//  Created by Micaella Morales on 3/6/21.
//

import UIKit
import Parse
import RSKImageCropper

class ProfileViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, RSKImageCropViewControllerDelegate {
    
    @IBOutlet var navigationView: UIView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet var bioLabel: UILabel!
    @IBOutlet var postCollectionView: UICollectionView!
    @IBOutlet var editProfileButton: UIButton!
    
    var user: PFUser!
    var userPosts = [Post]()
    var postsQueryLimit = 10
    var imagePicker: UIImagePickerController!
    var imageCropViewController: RSKImageCropViewController!
    var logOutActionSheet: UIAlertController!
    var profileImageActionSheet: UIAlertController!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.addSubview(navigationView)
        
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        editProfileButton.layer.borderWidth = 1
        editProfileButton.layer.borderColor = UIColor.lightGray.cgColor
        
        createLogOutActionSheet()
        createProfileImageActionSheet()
        
        //sets the layout of the collection view
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        
        let width = (view.frame.size.width - layout.minimumInteritemSpacing*3) / 3
        layout.itemSize = CGSize(width: width, height: width)
        
        postCollectionView.collectionViewLayout = layout
        
        postCollectionView.dataSource = self
        postCollectionView.delegate = self
        
        user = PFUser.current()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        usernameLabel.text = user.username
        nameLabel.text = user["name"] as? String ?? ""
        bioLabel.text = user["bio"] as? String ?? ""
        
        if let imageFile = user["profile_photo"] as? PFFileObject {
            profileImageView.image = Image.getImageFromFile(imageFile)
        }
        
        Post.loadPosts(postsQueryLimit, constraints: ["user": user!]) { (posts) in
            self.userPosts.removeAll()
            self.userPosts = posts
            self.postCollectionView.reloadData()
        }
    }
    
    @IBAction func onLogOutButton(_ sender: Any) {
        present(logOutActionSheet, animated: true, completion: nil)
    }
    
    @IBAction func onProfileImageView(_ sender: Any) {
        if !profileImageActionSheet.isBeingPresented {
            imagePicker = UIImagePickerController()
            imagePicker.delegate = self

            imagePicker.modalPresentationStyle = .fullScreen
            
            present(profileImageActionSheet, animated: true, completion: nil)
        }
    }
    
    func createLogOutActionSheet() {
        logOutActionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let logOutAction = UIAlertAction(title: "Log out", style: .default) { (action) in
            PFUser.logOut()
            
            let loginViewController = self.storyboard?.instantiateViewController(identifier: "LoginViewController")
        
            let sceneDelegate = UIApplication.shared.windows.first?.windowScene?.delegate as! SceneDelegate
            sceneDelegate.window?.rootViewController = loginViewController
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        logOutActionSheet.addAction(logOutAction)
        logOutActionSheet.addAction(cancelAction)
    }
    
    func createProfileImageActionSheet() {
        profileImageActionSheet = UIAlertController(title: "Change Profile Photo", message: nil, preferredStyle: .actionSheet)
        
        let takePhotoAction = UIAlertAction(title: "Take Photo", style: .default) { (_) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.imagePicker.sourceType = .camera
            }
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        let chooseFromLibAction = UIAlertAction(title: "Choose from Library", style: .default) { (_) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                self.imagePicker.sourceType = .photoLibrary
            }
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        profileImageActionSheet.addAction(takePhotoAction)
        profileImageActionSheet.addAction(chooseFromLibAction)
        profileImageActionSheet.addAction(cancelAction)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as! UIImage
        
        imageCropViewController = RSKImageCropViewController.init(image: image, cropMode: .circle)
        imageCropViewController.delegate = self

        imagePicker.pushViewController(imageCropViewController, animated: true)
    }
    
    func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect, rotationAngle: CGFloat) {
        let size = CGSize(width: 300, height: 300)
        let image = croppedImage.af.imageRoundedIntoCircle()
        let scaledImage = image.af.imageAspectScaled(toFill: size)
        
        let imageData = scaledImage.pngData()
        let imageFile = PFFileObject(data: imageData!)
        
        user["profile_photo"] = imageFile
        user.saveInBackground { (success, error) in
            if success {
                let tBController = self.tabBarController as! TabBarController
                tBController.setProfileTabImage(scaledImage)
            } else {
                print("Error: \(String(describing: error?.localizedDescription))")
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userPosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = postCollectionView.dequeueReusableCell(withReuseIdentifier: "UserPostCell", for: indexPath) as! UserPostCell
        
        cell.post = userPosts[indexPath.row]
        
        return cell
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        
        let navController = segue.destination as! UINavigationController
        
        // Pass the selected object to the new view controller.
        if segue.identifier == "editProfileSegue" {
            if let controller = navController.topViewController as? EditProfileViewController {
                controller.tBController = self.tabBarController as? TabBarController
            }
        } else if segue.identifier == "postSegue" {
            postCollectionView.delegate = self
            
            //Find the selected post
            let cell = sender as! UICollectionViewCell
            let indexPath = postCollectionView.indexPath(for: cell)!
            let post = userPosts[indexPath.row]
            
            if let controller = navController.topViewController as? PostViewController {
                controller.post = post
            }
        }
    }
    

}
