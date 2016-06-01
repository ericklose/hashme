//
//  TrailReportData.swift
//  Hash Me
//
//  Created by Eric Klose on 5/25/16.
//  Copyright © 2016 Eric Klose. All rights reserved.
//

import Foundation
import FirebaseDatabase

class TrailReportData {
    
    private var _trailKey: String!
    private var _attendeeCount: Int!
    private var _revenue: Int!
    private var _paidAttendee: Int!
    
    
//    _paidAttendee = 0
//    _attendeeCount = 0
//    _revenue = 0
    
    var trailKey: String {
        return _trailKey
    }
    
    var revenue: Int {
        return _revenue
    }
    
    var attendeeCount: Int {
        if _attendeeCount == nil {
            return 0
        }
        return _attendeeCount
    }
    
    var paidAttendee: Int {
        return _paidAttendee
    }
    
    
    init(trailKey: String) {
        
        self._trailKey = trailKey
        
        DataService.ds.REF_TRAILS.child(self._trailKey).child("trailAttendees").observeEventType(.Value, withBlock: { snapshot in

            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    if let trailDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        print("trailDict: ", trailDict)
                        if let attendeeWasThere = trailDict["trailAttendeePresent"] as? Int {
                            print("made it here")
                            print("test, ", attendeeWasThere)
                            self._attendeeCount = self._attendeeCount + 1
                            print("and here")
                        }
                        if let trailAttendeePaidAmt = trailDict["trailAttendeePaidAmt"] {
                            self._revenue = self._revenue + Int(trailAttendeePaidAmt as! NSNumber)
                            self._paidAttendee = self._paidAttendee + 1
                        }
                    }
                }
            }
            
        })
    }
    
    
}