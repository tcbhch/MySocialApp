//
//  SignInVC.swift
//  MySocialApp
//
//  Created by Hyperactive5 on 12/04/2017.
//  Copyright © 2017 Hyperactive5. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase

class SignInVC: UIViewController {

    @IBOutlet weak var emailField: FancyField!
    
    @IBOutlet weak var pswdField: FancyField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }


    @IBAction func facebookBtnPressed(_ sender: UIButton) {
         let facebookLogin = FBSDKLoginManager()
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("Unable to authenticated with facebook. error: \(error.debugDescription)")
            } else if result?.isCancelled == true{
                print("User canceled facebook authentication")
            } else {
                print("Successfully authenticated with facebook")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
    }
    
    func firebaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { ( user, error) in
            if error != nil {
                print("Unable to authenticated with firebase. error: \(error.debugDescription)")
            } else {
                print("Successfully authenticated with firebase")
            }
        })
    }
    
    @IBAction func signInBtnPressed(_ sender: UIButton) {
        if let email = emailField.text, let pswd = pswdField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: pswd, completion: { (user, error) in
                if error == nil {
                    print("Email user authenticated with firebase")
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: pswd, completion: { (user, error) in
                        if error != nil {
                            print("Unable to authenticated with firebase usig email. error: \(error.debugDescription)")
                        } else {
                            print("Successfully authenticated with firebase using email")
                        }
                    })
                }
            })
        }
    }
    
    
}

