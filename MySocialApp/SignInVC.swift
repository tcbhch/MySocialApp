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
import SwiftKeychainWrapper

class SignInVC: UIViewController {

    @IBOutlet weak var emailField: FancyField!
    
    @IBOutlet weak var pswdField: FancyField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }
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
                if let user = user {
                   self.completeSignIn(id: user.uid)
                }
            }
        })
    }
    
    @IBAction func signInBtnPressed(_ sender: UIButton) {
        if let email = emailField.text, let pswd = pswdField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: pswd, completion: { (user, error) in
                if error == nil {
                    print("Email user authenticated with firebase")
                    if let user = user {
                        self.completeSignIn(id: user.uid)
                    }
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: pswd, completion: { (user, error) in
                        if error != nil {
                            print("Unable to authenticated with firebase usig email. error: \(error.debugDescription)")
                        } else {
                            print("Successfully authenticated with firebase using email")
                            if let user = user {
                                self.completeSignIn(id: user.uid)
                            }
                        }
                    })
                }
            })
        }
    }
    
    func completeSignIn(id:String) {
        let keychainResult = KeychainWrapper.standard.set(id,forKey:KEY_UID)
        print("Data saved to keychain: \(keychainResult)")
        performSegue(withIdentifier: "goToFeed", sender: nil)
    }
}

