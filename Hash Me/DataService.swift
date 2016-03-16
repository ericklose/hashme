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
    private var _REF_TRAILS = Firebase(url: "\(URL_BASE)/trails")
    private var _REF_HASHERS = Firebase(url: "\(URL_BASE)/hashers")
    private var _REF_TRAILS_ATTENDED = Firebase(url: "\(URL_BASE)/hashers/???/trailsattended")
    
    var REF_BASE: Firebase {
        return _REF_BASE
    }
    
    var REF_TRAILS: Firebase {
        return _REF_TRAILS
    }
    
    var REF_HASHERS: Firebase {
        return _REF_HASHERS
    }
    
    var REF_TRAILS_ATTENDED: Firebase {
        return _REF_TRAILS_ATTENDED
    }
    
    var REF_HASHER_CURRENT: Firebase {
        print(KEY_UID)
        let uid = NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) as! String
        let hasher = Firebase(url: "\(URL_BASE)").childByAppendingPath("hashers").childByAppendingPath(uid)
        return hasher!
    }
        
    func createFirebaseUser(uid: String, hasher: Dictionary<String, String>) {
        REF_HASHERS.childByAppendingPath(uid).setValue(hasher)
    }
}
