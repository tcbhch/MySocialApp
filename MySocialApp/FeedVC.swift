//
//  FeedVC.swift
//  MySocialApp
//
//  Created by Hyperactive5 on 13/04/2017.
//  Copyright © 2017 Hyperactive5. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class FeedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    @IBAction func signOutBtnPressed(_ sender: UIButton) {
        if KeychainWrapper.standard.removeObject(forKey: KEY_UID) == true {
            try! FIRAuth.auth()?.signOut()
            dismiss(animated: true, completion: nil)
        }
       
    }
}
