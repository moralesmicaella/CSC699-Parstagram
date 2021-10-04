//
//  SignUp3ViewController.swift
//  Parstagram
//
//  Created by Micaella Morales on 3/5/21.
//

import UIKit
import Parse

class CreatePasswordViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    var user: PFUser!
    var eyeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setButtonForPasswordTextField()
        passwordTextField.becomeFirstResponder()
    }
    
    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onSignUpButton(_ sender: Any) {
        if !passwordTextField.text!.isEmpty {
            user.password = passwordTextField.text!
            user.signUpInBackground { (success, error) in
                if success {
                    self.performSegue(withIdentifier: "createPasswordSegue", sender: self)
                } else {
                    print("Error: \(String(describing: error?.localizedDescription))")
                }
            }
        }
    }
    
    @IBAction func textFieldDidEditingChanged(_ sender: Any) {
        if passwordTextField.text!.isEmpty {
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
    
    @objc func toggleHidePassword(_ sender: Any) {
        if passwordTextField.isSecureTextEntry {
            passwordTextField.isSecureTextEntry.toggle()
            eyeButton.tintColor = .systemBlue
        } else {
            passwordTextField.isSecureTextEntry.toggle()
            eyeButton.tintColor = .lightGray
        }
    }
    
    func setButtonForPasswordTextField() {
        let buttonViewWidth = 60
        let buttonViewHeight = passwordTextField.frame.size.height
        let buttonView = UIView(frame: CGRect(x: 0, y: 0, width: buttonViewWidth, height: Int(buttonViewHeight)))
        
        let buttonWidth = 30
        eyeButton = UIButton(type: .custom)
        eyeButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        eyeButton.tintColor = .lightGray
        eyeButton.frame = CGRect(x: buttonViewWidth / 2 - buttonWidth / 2, y: 0, width: buttonWidth, height: Int(buttonViewHeight))
        eyeButton.addTarget(self, action: #selector(toggleHidePassword(_:)), for: .touchUpInside)
        
        buttonView.addSubview(eyeButton)
        passwordTextField.rightView = buttonView
        passwordTextField.rightViewMode = .always
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
