//
//  TrailData.swift
//  Hash Me
//
//  Created by Eric Klose on 3/12/16.
//  Copyright © 2016 Eric Klose. All rights reserved.
//

import Foundation
import Firebase

class TrailData {
    
    private var _trailDate: String!
    private var _trailKennelName: String!
    private var _trailKennelId: String!
    private var _trailHares: String!
    private var _trailTitle: String!
    private var _trailStartLocation: String!
    private var _trailDescription: String!
    private var _trailKey: String!
    private var _trailHashCash: Int!
    private var _trailRef: Firebase!
    
    var trailDate: String {
        return _trailDate
    }
    
    var trailKennelName: String {
        if _trailKennelName == nil {
            return "No Name H3??"
        } else {
            return _trailKennelName
        }
    }
    
    var trailKennelId: String {
        if _trailKennelId == nil {
            return "xxx123"
        } else {
            return _trailKennelId
        }
    }
    
    var trailTitle: String {
        return _trailTitle
    }
    
    var trailHashCash: Int {
        if _trailHashCash == nil {
            return 25
        }
        return _trailHashCash
    }
    
    var trailHares: String {
        if _trailHares == nil {
            return "TBD"
        }
        return _trailHares
    }
    
    var trailStartLocation: String {
        if _trailStartLocation == nil {
            return "TBD"
        }
        return _trailStartLocation
    }
    
    var trailDescription: String {
        if _trailDescription == nil {
            return "TBD"
        }
        return _trailDescription
    }
    
    var trailKey: String {
        return _trailKey
    }
    
    init(trailDate: String, trailKennelName: String, trailKennelId: String, trailTitle: String) {
        self._trailDate = trailDate
        self._trailKennelId = trailKennelId
        self._trailKennelName = trailKennelName
        self._trailTitle = trailTitle
        
    }
    
    init(trailKey: String, dictionary: Dictionary<String, AnyObject>) {
        
        self._trailKey = trailKey
        
        if let trailDate = dictionary["trailDate"] as? String {
            self._trailDate = trailDate
        }
        
        if let trailKennelName = dictionary["trailKennelName"] as? String {
            self._trailKennelName = trailKennelName
        }
        
        if let trailKennelId = dictionary["trailKennelId"] as? String {
            self._trailKennelId = trailKennelId
        }
        
        if let trailTitle = dictionary["trailTitle"] as? String {
            self._trailTitle = trailTitle
        }
        
        if let trailHares = dictionary["trailHares"] as? String {
            self._trailHares = trailHares
        }
        
        if let trailStartLocation = dictionary["trailStartLocation"] as? String {
            self._trailStartLocation = trailStartLocation
        }
        
        if let trailDescription = dictionary["trailDescription"] as? String {
            self._trailDescription = trailDescription
        }
        
        if let trailHashCash = dictionary["trailHashCash"] as? Int {
            self._trailHashCash = trailHashCash
        }
        
        self._trailRef = DataService.ds.REF_TRAILS.childByAppendingPath(self._trailKey)
    }
    
}

