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
    
    fileprivate var _trailDate: String!
    fileprivate var _trailKennelName: String!
    fileprivate var _trailKennelId: String!
    fileprivate var _trailTitle: String!
    fileprivate var _trailStartLocation: String!
    fileprivate var _trailDescription: String!
    fileprivate var _trailKey: String!
    fileprivate var _trailHashCash: Int!
    fileprivate var _trailHares: Dictionary<String, String>!
    fileprivate var _trailUrl: FIRDatabaseReference!
    fileprivate var _kennelTrailUrl: FIRDatabaseReference!
    fileprivate var _trails: [TrailData]!
    fileprivate var _trailList: [String]!
    
//    private var _trailHares: [(String, String, String)]!
    
    //HARES SHOULD BE A TUPLE OF HASH ID, RELEVANT NAME, ROLE NAME (Hare vs Bag Car)
    
    var trailDate: String {
        return _trailDate
    }
    
//    var trailHares: [(String, String, String)] {
//        return _trailHares
//    }
    
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
    
    var trails: [TrailData] {
        return _trails
    }
    
    var trailList: [String] {
        return _trailList
    }
    
//This isn't used ... eventually I should have ways to generate a trail list on any criteria (time, kennel, etc) and feed that list to the data grabber.
//Maybe it makes sense to have one function that does all of that, but it seems like a lot of looping to iterate through trails to determine which one(s) to return
//Probably that's the answer since that's the freaking point of JSON ... though then I need to figure out how to return All (or eliminate that option and always cap it)
    func getTrailListForKennel(_ completed: @escaping DownloadComplete, kennelId: String) {
        DataService.ds.REF_KENNELS.child(kennelId).observe(.value, with: { snapshot in
            
            self._trails = []
            
            if let kennelDict = snapshot.value as? Dictionary<String, AnyObject> {
                if var trailDict = kennelDict["kennelTrails"] as? Dictionary<String, AnyObject> {
                    for trail in trailDict {
                        trailDict["trailKennelId"] = kennelId as AnyObject?
                        let key = trail.0
                        if let finalTrailDict = trailDict[key] as? Dictionary<String, AnyObject> {
                            let trail = TrailData(trailKey: key, dictionary: finalTrailDict)
                            self._trails.append(trail)
                        }
                    }
                }
            }
            completed()
        })
    }
    
    func getTrailInfo(_ completed: @escaping DownloadComplete) {
        DataService.ds.REF_TRAILS.observe(.value, with: { snapshot in
            
            self._trails = []
            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    if let trailDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let trail = TrailData(trailKey: key, dictionary: trailDict)
                        self._trails.append(trail)
                    }
                }
            }
            completed()
        })
    }
    
    func trailSetDate(_ trailKey: String, newTrailDate: String) {
        _trailUrl.updateChildValues(["trailDate" : newTrailDate])
        _kennelTrailUrl.updateChildValues(["trailDate" : newTrailDate])
    }
    
    func trailSetDescription(_ trailKey: String, newTrailDescription: String) {
        _trailUrl.updateChildValues(["trailDescription" : newTrailDescription])
        _kennelTrailUrl.updateChildValues(["trailDescription" : newTrailDescription])
    }
    
    func trailSetHashCash(_ trailKey: String, newTrailHashCash: Int) {
        _trailUrl.updateChildValues(["trailHashCash" : newTrailHashCash])
        _kennelTrailUrl.updateChildValues(["trailHashCash" : newTrailHashCash])
    }
    
    func trailSetTitle(_ trailKey: String, newTrailTitle: String) {
        _trailUrl.updateChildValues(["trailTitle" : newTrailTitle])
        _kennelTrailUrl.updateChildValues(["trailTitle" : newTrailTitle])
    }
    
    func trailSetStartLocation(_ trailKey: String, newTrailStartLocation: String) {
        _trailUrl.updateChildValues(["trailStartLocation" : newTrailStartLocation])
        _kennelTrailUrl.updateChildValues(["trailStartLocation" : newTrailStartLocation])
    }
    
    func trailAddHare(_ trailKey: String, newTrailHareHasherId: String, trailRole: String) {
        _trailUrl.child("trailHares").updateChildValues([newTrailHareHasherId : trailRole])
        _kennelTrailUrl.child("trailHares").updateChildValues([newTrailHareHasherId : trailRole])
    }
    
    func trailRemoveHare(_ trailKey: String, exTrailHareHasherId: String) {
        _trailUrl.child("trailHares").child(exTrailHareHasherId).removeValue()
        _kennelTrailUrl.child("trailHares").child(exTrailHareHasherId).removeValue()
    }
    
    func trailAddTrail(_ trailDict: Dictionary<String, AnyObject>) {
        let firstAdd = DataService.ds.REF_TRAILS.childByAutoId()
        let trailRef = firstAdd.key
        _trailUrl.setValue(trailDict)
        DataService.ds.REF_KENNELS.child(_trailKennelId).child("kennelTrails").child(trailRef).setValue(trailDict)
    }
    
    init(isFake: String) {
        print("Fake Trail Initializer (figure out a better way to do this sometime): ", isFake)
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

