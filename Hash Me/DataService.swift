//
//  DataService.swift
//  Hash Me
//
//  Created by Eric Klose on 3/12/16.
//  Copyright © 2016 Eric Klose. All rights reserved.
//

import Foundation
import FirebaseDatabase

//let URL_BASE = "https://hash-me-dev.firebaseio.com/"
//let URL_BASE = "https://hashme.firebaseio.com"

class DataService {
    static let ds = DataService()
    
    private var _REF_BASE = FIRDatabase.database().reference()
    private var _REF_TRAILS = FIRDatabase.database().referenceWithPath("trails")
    private var _REF_HASHERS = FIRDatabase.database().referenceWithPath("hashers")
    private var _REF_KENNELS = FIRDatabase.database().referenceWithPath("kennels")
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
        let uid = "7be00fdd-8aa6-43fe-bb6d-b53c255bab7a"
        let user = FIRDatabase.database().referenceWithPath("hashers").child(uid)
        return user
        //        print("uid is: \(KEY_UID)")
        //        let uid = NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) as! String
        //        let user = FIRDatabase.database().referenceWithPath("hashers").child(uid)
        //        return user
    }
    
    func createFirebaseUser(uid: String, user: Dictionary<String, String>) {
        REF_HASHERS.child(uid).setValue(user)
    }
    
    
}
