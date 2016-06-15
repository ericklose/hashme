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
    private var _trailTitle: String!
    private var _trailStartLocation: String!
    private var _trailDescription: String!
    private var _trailKey: String!
    private var _trailHashCash: Int!
    private var _trailHares: Dictionary<String, String>!
    private var _trailUrl: FIRDatabaseReference!
    private var _kennelTrailUrl: FIRDatabaseReference!
    
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
            return 5
        } else {
            return _trailHashCash
        }
    }
    
    var trailHares: Dictionary<String, String> {
        if _trailHares == nil {
            _trailHares = ["Hare" : "TBD"]
            return _trailHares
        } else {
            return _trailHares
        }
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
    
    func trailSetDate(trailKey: String, newTrailDate: String) {
        _trailUrl.updateChildValues(["trailDate" : newTrailDate])
        _kennelTrailUrl.updateChildValues(["trailDate" : newTrailDate])
    }
    
    func trailSetDescription(trailKey: String, newTrailDescription: String) {
        _trailUrl.updateChildValues(["trailDescription" : newTrailDescription])
        _kennelTrailUrl.updateChildValues(["trailDescription" : newTrailDescription])
    }
    
    func trailSetHashCash(trailKey: String, newTrailHashCash: Int) {
        _trailUrl.updateChildValues(["trailHashCash" : newTrailHashCash])
        _kennelTrailUrl.updateChildValues(["trailHashCash" : newTrailHashCash])
    }
    
    func trailSetTitle(trailKey: String, newTrailTitle: String) {
        _trailUrl.updateChildValues(["trailTitle" : newTrailTitle])
        _kennelTrailUrl.updateChildValues(["trailTitle" : newTrailTitle])
    }
    
    func trailSetStartLocation(trailKey: String, newTrailStartLocation: String) {
        _trailUrl.updateChildValues(["trailStartLocation" : newTrailStartLocation])
        _kennelTrailUrl.updateChildValues(["trailStartLocation" : newTrailStartLocation])
    }
    
    func trailAddHare(trailKey: String, newTrailHareHasherId: String, trailRole: String) {
        _trailUrl.child("trailHares").updateChildValues([newTrailHareHasherId : trailRole])
        _kennelTrailUrl.child("trailHares").updateChildValues([newTrailHareHasherId : trailRole])
    }
    
    func trailRemoveHare(trailKey: String, exTrailHareHasherId: String) {
        _trailUrl.child("trailHares").child(exTrailHareHasherId).removeValue()
        _kennelTrailUrl.child("trailHares").child(exTrailHareHasherId).removeValue()
    }
    
    func trailAddTrail(trailDict: Dictionary<String, AnyObject>) {
        let firstAdd = DataService.ds.REF_TRAILS.childByAutoId()
        let trailRef = firstAdd.key
        _trailUrl.setValue(trailDict)
        DataService.ds.REF_KENNELS.child(_trailKennelId).child("kennelTrails").child(trailRef).setValue(trailDict)
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
        
        if let trailHares = dictionary["trailHares"] as? Dictionary<String, String> {
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

        self._trailUrl = DataService.ds.REF_TRAILS.child(_trailKey)
        self._kennelTrailUrl = DataService.ds.REF_KENNELS.child(_trailKennelId).child("kennelTrails").child(_trailKey)
        
    }
    
}

