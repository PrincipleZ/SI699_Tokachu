//
//  ViewController.swift
//  Tokachu
//
//  Created by Yuanze Zhang on 11/6/18.
//  Copyright © 2018 Tokachu. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


    @IBAction func loginTapped(_ sender: Any) {
        WebServiceUtils.sharedInstance.logIn(username: usernameTextField.text!, password: passwordTextField.text!, completion: {success, msg in
            if !success{
                self.errorLabel.text = msg
            }
            else {
                self.performSegue(withIdentifier: "LogInSegue", sender: nil)
            }
        })
    }
}

