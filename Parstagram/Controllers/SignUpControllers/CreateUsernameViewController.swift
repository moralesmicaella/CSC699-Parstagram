//
//  SignUp2ViewController.swift
//  Parstagram
//
//  Created by Micaella Morales on 3/5/21.
//

import UIKit
import Parse

class CreateUsernameViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    var user: PFUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        usernameTextField.becomeFirstResponder()
    }
    
    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextPage(_ sender: Any) {
        if !usernameTextField.text!.isEmpty {
            user.username = usernameTextField.text!
            performSegue(withIdentifier: "createUsernameSegue", sender: self)
        }
    }
    
    @IBAction func textFieldDidEditingChanged(_ sender: Any) {
        if usernameTextField.text!.isEmpty {
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
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        let controller = segue.destination as! CreatePasswordViewController
        
        // Pass the selected object to the new view controller.
        controller.user = user
    }
    

}
