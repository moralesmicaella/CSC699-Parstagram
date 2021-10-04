//
//  AddNameViewController.swift
//  Parstagram
//
//  Created by Micaella Morales on 3/6/21.
//

import UIKit
import Parse

class AddNameViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    var user: PFUser!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        nameTextField.becomeFirstResponder()
        
        user = PFUser.current()
    }

    @IBAction func nextPage(_ sender: Any) {
        if !nameTextField.text!.isEmpty {
            user["name"] = nameTextField.text
            user.saveInBackground { (success, error) in
                if success {
                    self.performSegue(withIdentifier: "addNameSegue", sender: self)
                } else {
                    print("Error: \(String(describing: error?.localizedDescription))")
                }
            }
        }
    }
    
    @IBAction func textFieldDidEditingChanged(_ sender: Any) {
        if nameTextField.text!.isEmpty {
            nextButton.isEnabled = false
            nextButton.alpha = 0.5
        } else {
            nextButton.isEnabled = true
            nextButton.alpha = 1.0
        }
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        view.endEditing(true)
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
