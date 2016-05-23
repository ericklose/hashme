//
//  DataService.swift
//  Hash Me
//
//  Created by Eric Klose on 3/12/16.
//  Copyright © 2016 Eric Klose. All rights reserved.
//

import Foundation
import Firebase

//let URL_BASE = "https://hash-me-dev.firebaseio.com/"
let URL_BASE = "https://hashme.firebaseio.com"

class DataService {
    static let ds = DataService()
    
    private var _REF_BASE = Firebase(url: "\(URL_BASE)")
    private var _REF_TRAILS = Firebase(url: "\(URL_BASE)/trails")
    private var _REF_HASHERS = Firebase(url: "\(URL_BASE)/hashers")
    private var _REF_KENNELS = Firebase(url: "\(URL_BASE)/kennels")
    //NEW
    //REF_HASHER_UID is the ID for the hasher owned by the user. The naming is bad but this was the least destructive way to change it.
    private var _REF_HASHER_USERID: String!
    //REF_UID is the user ID which is logged in. Since it isn't a hasher ID, it really shouldn't be used (unless we want to give Eric & Holly global admin or something).
    //    private var _REF_UID = NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) as? String
    
    
    var REF_BASE: Firebase {
        return _REF_BASE
    }
    
    var REF_TRAILS: Firebase {
        return _REF_TRAILS
    }
    
    var REF_HASHERS: Firebase {
        return _REF_HASHERS
    }
    
    var REF_KENNELS: Firebase {
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
    
    var REF_USER_CURRENT: Firebase {
        print("uid is: \(KEY_UID)")
        let uid = NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) as! String
        let user = Firebase(url: "\(URL_BASE)").childByAppendingPath("hashers").childByAppendingPath(uid)
        return user!
    }
    
    func createFirebaseUser(uid: String, user: Dictionary<String, String>) {
        REF_HASHERS.childByAppendingPath(uid).setValue(user)
    }
    
    
}
