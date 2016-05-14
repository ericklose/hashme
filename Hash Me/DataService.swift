//
//  DataService.swift
//  Hash Me
//
//  Created by Eric Klose on 3/12/16.
//  Copyright © 2016 Eric Klose. All rights reserved.
//

import Foundation
import Firebase

let URL_BASE = "https://hash-me-dev.firebaseio.com/"
//let URL_BASE = "https://hashme.firebaseio.com"

class DataService {
    static let ds = DataService()
    
    private var _REF_BASE = Firebase(url: "\(URL_BASE)")
    private var _REF_TRAILS = Firebase(url: "\(URL_BASE)/trails")
    private var _REF_HASHERS = Firebase(url: "\(URL_BASE)/hashers")
    private var _REF_KENNELS = Firebase(url: "\(URL_BASE)/kennels")
    //ORIGINAL
    //private var _REF_HASHER_UID = NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) as? String
    //note that the ClaimHasherIdVC now uses REF_UID instead of originally using REF_HASHER_UID so that's a change to undo too if needed
    //NEW
    //REF_HASHER_UID is the ID for the hasher owned by the user. The naming is bad but this was the least destructive way to change it.
    private var _REF_HASHER_UID: String!
    //REF_UID is the user ID which is logged in. Since it isn't a hasher ID, it really shouldn't be used (unless we want to give Eric & Holly global admin or something).
    private var _REF_UID = NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) as? String
    
    
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
        return _REF_UID
    }
    
    //ORIGINAL TO REVERT TO
    //    var REF_HASHER_USERID: String {
    //        return _REF_HASHER_UID!
    //    }
    
    //NEW SYSTEM
    func updateRefHasherUserId(hasherId: String) {
        _REF_HASHER_UID = hasherId
    }
    
    var REF_HASHER_USERID: String {
            return _REF_HASHER_UID
    }
    //END OF NEW SYSTEM CHANGES
    
    //SHIT, THIS PROBABLY NEEDS TO BE DISABLED
    var REF_HASHER_CURRENT: Firebase {
        let uid = NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) as! String
        let hasher = Firebase(url: "\(URL_BASE)").childByAppendingPath("hashers").childByAppendingPath(uid)
        return hasher!
    }
    
    func createFirebaseUser(uid: String, hasher: Dictionary<String, String>) {
        REF_HASHERS.childByAppendingPath(uid).setValue(hasher)
        //ADD TO THE HASHER-UID DECODER TABLE??? OR DO A "NIL" LOOKUP TO ID WHO'S MISSING FROM TABLE?
        //I'M 90% CERTAIN EVERYONE GOES IN THE TABLE, IN PART AS A "CLAIM A PROFILE" DETECTOR
    }
}
