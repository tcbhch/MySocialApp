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
}

