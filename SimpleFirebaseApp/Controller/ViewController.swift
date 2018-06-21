//
//  ViewController.swift
//  SimpleFirebaseApp
//
//  Created by Darkhan on 02.04.18.
//  Copyright © 2018 SDU. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
class ViewController: UIViewController {
    @IBOutlet weak var email_field: UITextField!
    
    @IBOutlet weak var password_field: UITextField!
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let current_user = FIRAuth.auth()?.currentUser
        if current_user != nil{
            performSegue(withIdentifier: "mySegue1", sender: self)
        }
    }

    @IBAction func signUpPressed(_ sender: UIButton) {
        indicator.startAnimating()
        
        FIRAuth.auth()?.createUser(withEmail: email_field.text!, password: password_field.text!, completion: { (user, error) in
           
            self.indicator.stopAnimating()
            if error == nil{
                user?.sendEmailVerification(completion: { (error) in
                    if error == nil{
                        self.messageLabel.text = "Check your email.We sent you a verification link"
                        self.messageLabel.textColor = UIColor.green
                    }
                })

                //self.performSegue(withIdentifier: "signInSegue", sender: self)
            }else{
                self.messageLabel.text = "Something is wrong!"
                self.messageLabel.textColor = UIColor.red
            }
        })
    }
    
    
    @IBAction func signInPressed(_ sender: UITapGestureRecognizer) {
        
    }
    

}

