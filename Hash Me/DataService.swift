//
//  DataService.swift
//  Hash Me
//
//  Created by Eric Klose on 3/12/16.
//  Copyright © 2016 Eric Klose. All rights reserved.
//

import Foundation
import Firebase

let URL_BASE = "https://hashme.firebaseio.com"

class DataService {
    static let ds = DataService()
    
    private var _REF_BASE = Firebase(url: "\(URL_BASE)")
<<<<<<< HEAD
    private var _REF_POST = Firebase(url: "\(URL_BASE)/trails")
    private var _REF_USERS = Firebase(url: "\(URL_BASE)/hashers")
=======
    private var _REF_TRAILS = Firebase(url: "\(URL_BASE)/trails")
    private var _REF_HASHERS = Firebase(url: "\(URL_BASE)/hashers")
>>>>>>> dc3eaaf18d7b088549244e08038e36175300116d
    
    var REF_BASE: Firebase {
        return _REF_BASE
    }
    
    var REF_TRAILS: Firebase {
        return _REF_TRAILS
    }
    
    var REF_HASHERS: Firebase {
        return _REF_HASHERS
    }
    
    var REF_USER_CURRENT: Firebase {
        let uid = NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) as! String
        let user = Firebase(url: "\(URL_BASE)").childByAppendingPath("users").childByAppendingPath(uid)
        return user!
    }
    
    func createFirebaseUser(uid: String, user: Dictionary<String, String>) {
        REF_HASHERS.childByAppendingPath(uid).setValue(user)
    }
}
