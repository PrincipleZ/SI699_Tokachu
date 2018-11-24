//
//  RegisterViewController.swift
//  Tokachu
//
//  Created by Yuanze Zhang on 11/24/18.
//  Copyright © 2018 Tokachu. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passwordConfirm: UITextField!
    @IBOutlet weak var errorMsg: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        firstName.delegate = self
        lastName.delegate = self
        emailAddress.delegate = self
        password.delegate = self
        passwordConfirm.delegate = self
        setUpTextFieldTags()
        self.hideKeyboardWhenTappedAround()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.isSecureTextEntry{
            if textField.text != password.text {
                errorMsg.text = "Password doesn't match"
            } else {
                errorMsg.text = ""
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        // Try to find next responder
        let nextResponder = textField.superview?.viewWithTag(nextTag)
        
        if nextResponder != nil {
            // Found next responder, so set it
            nextResponder!.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard
            textField.resignFirstResponder()
        }
        
        return false
    }
    
    func setUpTextFieldTags(){
        firstName.tag = 0
        lastName.tag = 1
        emailAddress.tag = 2
        password.tag = 3
        passwordConfirm.tag = 4
    }
    @IBAction func register(_ sender: Any) {
        if firstName.text == "" || lastName.text == "" || emailAddress.text == "" || password.text == "" || passwordConfirm.text == "" {
            errorMsg.text = "Some fields are missing"
            return
        }
        if password.text !=  passwordConfirm.text {
            errorMsg.text = "Password doesn't match"
            return
        }
        errorMsg.text = ""
        WebServiceUtils.sharedInstance.register(firstName: firstName.text!, lastName: lastName.text!, email: emailAddress.text!, password: password.text!, completion: {(success, error) in
            if !success {
                self.errorMsg.text = error
            } else {
                self.performSegue(withIdentifier: "RegisterSeague", sender: nil)
            }
        })
        
    }
    
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
