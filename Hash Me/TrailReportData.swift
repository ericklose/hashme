//
//  TrailReportData.swift
//  Hash Me
//
//  Created by Eric Klose on 5/25/16.
//  Copyright © 2016 Eric Klose. All rights reserved.
//

import Foundation
import Firebase

class TrailReportData {
    
    fileprivate var _trailKey: String!
    fileprivate var _attendeeCount: Int!
    fileprivate var _revenue: Int!
    fileprivate var _paidAttendee: Int!
    
    var trailKey: String {
        return _trailKey
    }
    
    var revenue: Int {
        if _revenue == nil {
            return 0
        }
        return _revenue
    }
    
    var attendeeCount: Int {
        if _attendeeCount == nil {
            return 0
        }
        return _attendeeCount
    }
    
    var paidAttendee: Int {
        if _paidAttendee == nil {
            return 0
        }
        return _paidAttendee
    }
    
    
    init(trailKey: String, completed: @escaping DownloadComplete) {
        
        self._trailKey = trailKey
        
        DataService.ds.REF_TRAILS.child(self._trailKey).child("trailAttendees").observe(.value, with: { snapshot in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    if let trailDict = snap.value as? Dictionary<String, AnyObject> {
                        if let _ = trailDict["trailAttendeePresent"] as? Int {
                            self._attendeeCount = self.attendeeCount + 1
                        }
                        if let trailAttendeePaidAmt = trailDict["trailAttendeePaidAmt"] {
                            self._revenue = self.revenue + Int(trailAttendeePaidAmt as! NSNumber)
                            self._paidAttendee = self.paidAttendee + 1
                        }
                    }
                }
            }
            completed()
        })
    }
}
