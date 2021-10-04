//
//  SignupViewController.swift
//  Parstagram
//
//  Created by Micaella Morales on 3/4/21.
//

import UIKit
import Parse

class EnterEmailViewController: UIViewController {

    @IBOutlet var toolbarView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet var nextButtonTopConstraint: NSLayoutConstraint!
    
    var invalidLabel: UILabel!
    var user: PFUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.toolbar.addSubview(toolbarView)
        
        createInvalidLabel()
        emailTextField.becomeFirstResponder()
        user = PFUser()
    }
    
    @IBAction func cancelSignup(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextPage(_ sender: Any) {
        if !emailTextField.text!.isEmpty {
            user.email = emailTextField.text!
            if isValidEmail(user.email!) {
                performSegue(withIdentifier: "enterEmailSegue", sender: self)
            } else {
                showInvalidLabel()
            }
        }
    }
    
    @IBAction func textFieldDidEditingChanged(_ sender: Any) {
        if emailTextField.text!.isEmpty {
            nextButton.isEnabled = false
            nextButton.alpha = 0.5
        } else {
            nextButton.isEnabled = true
            nextButton.alpha = 1.0
        }
        
        if !invalidLabel.isHidden {
            hideInvalidLabel()
        }
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        view.endEditing(true)
    }
    
    func createInvalidLabel() {
        let origin = CGPoint(x: emailTextField.frame.origin.x, y: emailTextField.frame.origin.y + emailTextField.frame.height + 5)
        let size = CGSize(width: emailTextField.frame.size.width, height: 15)
        invalidLabel = UILabel(frame: CGRect(origin: origin, size: size))
        invalidLabel.text = "Invalid Email Address"
        invalidLabel.font = UIFont(name: "Helvetica Neue Light", size: 12)
        invalidLabel.isHidden = true
    }
    
    func hideInvalidLabel() {
        emailTextField.layer.borderWidth = 0
        invalidLabel.removeFromSuperview()
        nextButtonTopConstraint.isActive = true
        invalidLabel.isHidden = true
    }
    
    func showInvalidLabel() {
        emailTextField.layer.borderWidth = 1
        emailTextField.layer.cornerRadius = 5
        emailTextField.layer.borderColor = UIColor.red.cgColor

        invalidLabel.textColor = .red
        invalidLabel.isHidden = false

        view.addSubview(invalidLabel)
        
        nextButtonTopConstraint?.isActive = false
        invalidLabel.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor).isActive = true
        invalidLabel.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor)
            .isActive = true
        invalidLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 5).isActive = true
        nextButton.topAnchor.constraint(equalTo: invalidLabel.bottomAnchor, constant: 16).isActive = true
    }
    
    func isValidEmail(_ email: String) -> Bool {
        guard !email.lowercased().hasPrefix("mailto:") else {
            return false
        }
        guard let emailDetector
            = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) else {
            return false
        }
        let matches
            = emailDetector.matches(in: email,
                                    options: NSRegularExpression.MatchingOptions.anchored,
                                    range: NSRange(location: 0, length: email.count))
        guard matches.count == 1 else {
            return false
        }
        return matches[0].url?.scheme == "mailto"
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        let controller = segue.destination as! CreateUsernameViewController
        
        // Pass the selected object to the new view controller.
        controller.user = user
    }
    

}
