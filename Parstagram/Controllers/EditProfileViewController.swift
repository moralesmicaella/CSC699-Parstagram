//
//  EditProfileViewController.swift
//  Parstagram
//
//  Created by Micaella Morales on 3/16/21.
//

import UIKit
import Parse
import RSKImageCropper

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, RSKImageCropViewControllerDelegate, UITextViewDelegate {

    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var nameTextView: UITextView!
    @IBOutlet var usernameTextView: UITextView!
    @IBOutlet var bioTextView: UITextView!
    
    let user = PFUser.current()!
    var imagePicker: UIImagePickerController!
    var imageCropViewController: RSKImageCropViewController!
    var profileImageActionSheet: UIAlertController!
    var tBController: TabBarController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        
        createProfileImageActionSheet()
        
        nameTextView.delegate = self
        usernameTextView.delegate = self
        bioTextView.delegate = self
        
        nameTextView.placeholder = "Name"
        usernameTextView.placeholder = "Username"
        bioTextView.placeholder = "Bio"
        
        nameTextView.text = user["name"] as? String ?? ""
        usernameTextView.text = user.username
        bioTextView.text =  user["bio"] as? String ?? ""
        
        if let imageFile = user["profile_photo"] as? PFFileObject {
            profileImageView.image = Image.getImageFromFile(imageFile)
        }
        
        
    }
    
    @IBAction func onCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onDoneButton(_ sender: Any) {
        user.saveInBackground { (success, error) in
            if success {
                if let image = self.profileImageView.image {
                    self.tBController.setProfileTabImage(image)
                }
            } else {
                print("Error: \(String(describing: error?.localizedDescription))")
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func onChangeProfilePicture(_ sender: Any) {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        imagePicker.modalPresentationStyle = .fullScreen
        
        present(profileImageActionSheet, animated: true, completion: nil)
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        view.endEditing(true)
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
        
        profileImageView.image = scaledImage
        
        let imageData = scaledImage.pngData()
        let imageFile = PFFileObject(data: imageData!)

        user["profile_photo"] = imageFile
        
        dismiss(animated: true, completion: nil)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView == nameTextView {
            user["name"] = nameTextView.text
        } else if textView == usernameTextView {
            user.username = usernameTextView.text
        } else {
            user["bio"] = bioTextView.text
        }
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
