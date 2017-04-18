//
//  DataService.swift
//  MySocialApp
//
//  Created by Hyperactive5 on 13/04/2017.
//  Copyright © 2017 Hyperactive5. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = FIRDatabase.database().reference()
let STORAGE_BASE = FIRStorage.storage().reference()

class DataService {
    
    static let ds = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_POSTS = DB_BASE.child("posts")
    private var _REF_USERS = DB_BASE.child("users")
    
    
    //storage ref
    private var _REF_POST_IMAGES = STORAGE_BASE.child("post-pics")
    
    var REF_BASE:FIRDatabaseReference {
        return _REF_BASE
    }
    
    var REF_POSTS:FIRDatabaseReference {
        return _REF_POSTS
    }
    
    var REF_USERS:FIRDatabaseReference {
        return _REF_USERS
    }
    
    var REF_POST_IMAGES:FIRStorageReference {
        return _REF_POST_IMAGES
    }
    
    func createFirbaseDBUser(uid:String,userData:[String:String]) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
}

