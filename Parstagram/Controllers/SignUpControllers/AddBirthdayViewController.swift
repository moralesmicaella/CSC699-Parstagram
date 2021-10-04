//
//  SignUp4ViewController.swift
//  Parstagram
//
//  Created by Micaella Morales on 3/5/21.
//

import UIKit
import Parse

class AddBirthdayViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dateTextField: UITextField!
    
    let dateFormat = "MMMM d, yyyy"
    
    var user: PFUser!
    var ageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationController?.delegate = self
        
        datePicker.maximumDate = Date()
        
        dateTextField.layer.borderWidth = 1
        dateTextField.layer.cornerRadius = 5
        dateTextField.layer.borderColor = UIColor.systemBlue.cgColor
        
        dateTextField.placeholder = getFormattedDate(format: dateFormat)
        
        setRightViewForDateTextField()
        
        user = PFUser.current()
    }
    
    @IBAction func nextPage(_ sender: Any) {
        user["birthday"] = datePicker.date
        user.saveInBackground { (success, error) in
            if success {
                self.performSegue(withIdentifier: "addBdaySegue", sender: self)
            } else {
                print("Error: \(String(describing: error?.localizedDescription))")
            }
        }
    }
    
    @IBAction func dateValueChanged(_ sender: Any) {
        dateTextField.text = getFormattedDate(format: dateFormat)
        ageLabel.text = String(format: "%d years old", getAge())
    }
    
    func getFormattedDate(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: datePicker.date)
    }
    
    func getAge() -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        
        let birthYear = dateFormatter.string(from: datePicker.date)
        let currYear = dateFormatter.string(from: Date())
        
        return Int(currYear)! - Int(birthYear)!
    }
    
    func setRightViewForDateTextField() {
        let labelWidth = 75
        let labelHeight = Int(dateTextField.frame.size.height)
        let labelView = UIView(frame: CGRect(x: 0, y: 0, width: labelWidth, height: labelHeight))
        
        ageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: labelWidth, height: labelHeight))
        ageLabel.textColor = .lightGray
        ageLabel.font = UIFont(name: "Helvetica Neue", size: 12)
        
        labelView.addSubview(ageLabel)
        
        dateTextField.rightView = labelView
        dateTextField.rightViewMode = .always
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
