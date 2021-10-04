//
//  AddProfileImageViewController.swift
//  Parstagram
//
//  Created by Micaella Morales on 3/6/21.
//

import UIKit
import Parse
import AlamofireImage
import RSKImageCropper

class AddProfilePhotoViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, RSKImageCropViewControllerDelegate {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var toolbarView: UIView!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    
    var user: PFUser!
    var isPhotoChosen: Bool!
    var photoActionSheet: UIAlertController!
    var imagePicker: UIImagePickerController!
    var imageCropViewController: RSKImageCropViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        createPhotoActionSheet()
        
        user = PFUser.current()
        isPhotoChosen = false
    }
    
    @IBAction func onBlueButton(_ sender: Any) {
        if !isPhotoChosen {
            imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            
            imagePicker.modalPresentationStyle = .fullScreen
            present(photoActionSheet, animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: "addProfilePhotoSegue", sender: self)
        }
    }
    
    @IBAction func onSkipButton(_ sender: Any) {
        performSegue(withIdentifier: "addProfilePhotoSegue", sender: self)
    }
    
    func createPhotoActionSheet() {
        photoActionSheet = UIAlertController(title: "Add Profile Photo", message: nil, preferredStyle: .actionSheet)
        
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
        
        photoActionSheet.addAction(takePhotoAction)
        photoActionSheet.addAction(chooseFromLibAction)
        photoActionSheet.addAction(cancelAction)
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
                self.isPhotoChosen = true
                self.profileImageView.image = scaledImage
                self.blueButton.setTitle("Next", for: .normal)
                self.label.text = "Profile photo added"
                self.skipButton.removeFromSuperview()
                self.toolbarView.heightAnchor.constraint(equalToConstant: 70).isActive = true
            } else {
                print("Error: \(String(describing: error?.localizedDescription))")
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination
        // Pass the selected object to the new view controller.
    }
    */
}
