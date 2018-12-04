//
//  ViewController.swift
//  Tokachu
//
//  Created by Yuanze Zhang on 11/6/18.
//  Copyright © 2018 Tokachu. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.hideKeyboardWhenTappedAround()
        passwordTextField.tag = 1
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        [self.emailTextField .becomeFirstResponder()]
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        // Try to find next responder
        let nextResponder = textField.superview?.viewWithTag(nextTag)
        
        if nextResponder != nil {
            // Found next responder, so set it
            nextResponder?.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard
            textField.resignFirstResponder()
        }
        
        return false
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        WebServiceUtils.sharedInstance.logIn(email: emailTextField.text!, password: passwordTextField.text!, completion: {success, msg in
            if !success{
                self.errorLabel.text = msg
            }
            else {
                WebServiceUtils.sharedInstance.getChannels()
                self.performSegue(withIdentifier: "LogInSegue", sender: nil)
            }
        })
    }
}

