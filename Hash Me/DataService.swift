//
//  DataService.swift
//  Hash Me
//
//  Created by Eric Klose on 3/12/16.
//  Copyright © 2016 Eric Klose. All rights reserved.
//

import Foundation
import Firebase

let URL_BASE = FIRDatabase.database().reference()

class DataService {
    static let ds = DataService()
    
    private var _REF_BASE = URL_BASE
    private var _REF_TRAILS = URL_BASE.child("trails")
    private var _REF_HASHERS = URL_BASE.child("hashers")
    private var _REF_KENNELS = URL_BASE.child("kennels")
    //NEW
    //REF_HASHER_UID is the ID for the hasher owned by the user. The naming is bad but this was the least destructive way to change it.
    private var _REF_HASHER_USERID: String!
    //REF_UID is the user ID which is logged in. Since it isn't a hasher ID, it really shouldn't be used (unless we want to give Eric & Holly global admin or something).
    //    private var _REF_UID = NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) as? String
    
    
    var REF_BASE: FIRDatabaseReference {
        return _REF_BASE
    }
    
    var REF_TRAILS: FIRDatabaseReference {
        return _REF_TRAILS
    }
    
    var REF_HASHERS: FIRDatabaseReference {
        return _REF_HASHERS
    }
    
    var REF_KENNELS: FIRDatabaseReference {
        return _REF_KENNELS
    }
    
    var REF_UID: String! {
        return NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) as? String
    }
    
    
    func storeRefHasherUserId(hasherId: String) {
        _REF_HASHER_USERID = hasherId
    }
    
    var REF_HASHER_USERID: String {
        return _REF_HASHER_USERID
    }
    
    var REF_USER_CURRENT: FIRDatabaseReference {
        let uid = NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) as! String
        let user = REF_HASHERS.child(uid)
        return user
    }
    
    func createFirebaseUser(uid: String, user: Dictionary<String, String>) {
        REF_HASHERS.child(uid).setValue(user)
    }
    
    
}
