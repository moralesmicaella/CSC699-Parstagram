//
//  SignupViewController.swift
//  Parstagram
//
//  Created by Micaella Morales on 3/13/19.
//  Copyright © 2019 Micaella Morales. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage

class SignupViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var bioTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        profileImageView.layer.cornerRadius = profileImageView.frame.size.width/2
    }
    
    @IBAction func createAccount(_ sender: Any) {
        let user = PFUser()
        let imageData = profileImageView.image!.pngData()
        let file = PFFileObject(data: imageData!)
        
        user.username = usernameTextField.text
        user.password = passwordTextField.text
        user["name"] = nameTextField.text
        user["bio"] = bioTextField.text
        user["profileImage"] = file
        
        user.signUpInBackground { (success, error) in
            if (success) {
                self.dismiss(animated: true, completion: nil)
            }
            else {
                print("Error: \(String(describing: error?.localizedDescription))")
            }
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onPhotoButton(_ sender: Any) {
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
        
        dismiss(animated: true, completion: nil)
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
