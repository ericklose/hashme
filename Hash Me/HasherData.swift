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
    
    private var _hasherNerdName: String!
    private var _hasherHashNames: String!
    private var _hasherKennelMemberships: Array<String>!
    private var _hasherTrailsAttended: Array<String>?
    private var _hasherTrailsHared: Array<String>?
    
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
    
    init (hasher: String) {
        self._hasherHashNames = hasher
    }
    
}