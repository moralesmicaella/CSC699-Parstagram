//
//  PostViewController.swift
//  Parstagram
//
//  Created by Micaella Morales on 3/9/21.
//

import UIKit
import Parse
import YPImagePicker
import AlamofireImage
import UITextView_Placeholder

class SharePostViewController: UIViewController {

    @IBOutlet var postImageView: UIImageView!
    @IBOutlet var captionTextView: UITextView!
    
    var image: UIImage!
    var errorMessage: UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view
        createErrorMessage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        postImageView.image = image
        captionTextView.placeholder = "Write a caption..."
        captionTextView.text = ""
        
    }
    
    @IBAction func onShareButton(_ sender: Any) {
        let size = CGSize(width: 300, height: 300)
        let scaledImage = image.af.imageScaled(to: size)
        
        let post = PFObject(className: "Posts")
        let imageData = scaledImage.pngData()
        let imageFile = PFFileObject(data: imageData!)
        
        post["user"] = PFUser.current()
        post["image"] = imageFile
        post["caption"] = captionTextView.text
        
        post.saveInBackground { (success, error) in
            if success {
                self.dismiss(animated: true, completion: nil)
            } else {
                self.present(self.errorMessage, animated: true, completion: nil)
                print("Error: \(String(describing: error?.localizedDescription))")
            }
        }
            
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        view.endEditing(true)
    }
    
    func createErrorMessage() {
        errorMessage = UIAlertController(title: "An error occured", message: "Try again later", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            self.dismiss(animated: true, completion: nil)
        }
        errorMessage.addAction(okAction)
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
