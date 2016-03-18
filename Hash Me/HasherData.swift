//
//  HasherData.swift
//  Hash Me
//
//  Created by Holly Klose on 3/13/16.
//  Copyright © 2016 Eric Klose. All rights reserved.
//

import Foundation
import Firebase

class Hasher {
    
    private var _hasherId: String!
    private var _hasherNerdName: String!
    private var _hasherHashNames: String!
    private var _hasherKennelMemberships: Array<String>!
    private var _hasherTrailsAttended: Array<String>?
    private var _hasherTrailsHared: Array<String>?
    
    var hasherId: String {
        return _hasherId
    }
    
    var hasherNerdName: String {
        return _hasherNerdName
    }
    
    var hasherHashNames: String {
        return _hasherHashNames
    }
    
    var hasherKennelMemberships: Array<String> {
        return _hasherKennelMemberships
    }
  
    var hasherTrailsAttended: Array<String>? {
        return _hasherTrailsAttended
        }
    
    var hasherTrailsHared: Array<String>? {
        return _hasherTrailsHared
    }
    
    init (hasherInitId: String, hasherInitDict: Dictionary<String, AnyObject>) {
        
        
        self._hasherId = hasherInitId
        
        if let hasherInitNerdName = hasherInitDict["hasherNerdName"] as? String {
            self._hasherNerdName = hasherInitNerdName
        }
    }
    
}