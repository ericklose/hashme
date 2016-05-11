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
    private var _REF_HASHER_UID = NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) as? String
//    private var _REF_HASHERID_OF_USER =

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
    
    var REF_HASHER_USERID: String {
        return _REF_HASHER_UID!
    }
    
    //THIS GETS LOOKED UP AT LOGIN, NOT HERE (PROBABLY) (BUT IT'S STILL SET HERE FOR FUTURE NEEDS)
    
//    var REF_HASHERID_FOR_USER: Firebase {
//      _REF_BASE.childByAppendingPath("UidToHasherId").childByAppendingPath(KEY_UID).observeSingleEventOfType(.Value) { snapshot in
//        return_
//        }
//    }
    
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
