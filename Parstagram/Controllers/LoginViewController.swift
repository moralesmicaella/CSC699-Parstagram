//
//  LoginViewController.swift
//  Parstagram
//
//  Created by Micaella Morales on 3/4/21.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var instagramLogo: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var logInTopConstraint: NSLayoutConstraint!
    
    var eyeButton: UIButton!
    var errorMessage: UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after
        setButtonForPasswordTextField()
        createErrorMessage()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if UserDefaults.standard.bool(forKey: "userLoggedIn") {
            self.performSegue(withIdentifier: "loginSegue", sender: self)
        }
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        let offset = instagramLogo.frame.origin.y - 20
        scrollView.contentOffset = CGPoint(x: 0, y: offset)
    }

    @objc func keyboardWillHide(_ notification: NSNotification) {
        scrollView.contentOffset = CGPoint(x: 0, y: 0)
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
    
    @IBAction func onLogInButton(_ sender: Any) {
        logIn()
    }
    
    @IBAction func onSignUpButton(_ sender: Any) {
        performSegue(withIdentifier: "signupSegue", sender: self)
    }
    
    @IBAction func nextTextField(_ sender: Any) {
        passwordTextField.becomeFirstResponder()
    }
    
    @IBAction func goLogIn(_ sender: Any) {
        if !usernameTextField.text!.isEmpty && !passwordTextField.text!.isEmpty {
            logIn()
        } else {
            present(errorMessage, animated: true, completion: nil)
            errorMessage.message = "Invalid parameters"
        }
    }
    
    @IBAction func textFieldDidEditingChanged(_ sender: Any) {
        if usernameTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            loginButton.isEnabled = false
            loginButton.alpha = 0.5
        } else {
            loginButton.isEnabled = true
            loginButton.alpha = 1.0
        }
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        view.endEditing(true)
    }

    
    func logIn() {
        PFUser.logInWithUsername(inBackground: usernameTextField.text!, password: passwordTextField.text!) { (user, error) in
            if user != nil {
                self.performSegue(withIdentifier: "loginSegue", sender: self)
            } else {
                self.present(self.errorMessage, animated: true, completion: nil)
                self.errorMessage.message = error?.localizedDescription
            }
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
    
    func createErrorMessage() {
        errorMessage = UIAlertController(title: "Error", message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        errorMessage.addAction(okAction)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        }
    }
    */

}
