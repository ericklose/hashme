//
//  AttendeeData.swift
//  Hash Me
//
//  Created by Eric Klose on 3/23/16.
//  Copyright © 2016 Eric Klose. All rights reserved.
//

import Foundation
import Firebase

class Attendee: Hasher {
    
    private var _attendeeRelevantHashName: String!
    private var _attendeeRelevantTrailId: String!
    private var _attendeePaidAmount: Int!
    private var _attendeePaidNotes: String!
    private var _attendeeHomeKennel: String!
    private var _attendeeVirginSponsor: String!
    //private var _attendeeAttending: Bool!
    
    var attendeeAttending: Bool!
    
    var attendeeRelevantHashName: String {
        return _attendeeRelevantHashName
    }
    
    var attendeeRelevantTrailId: String {
        return _attendeeRelevantTrailId
    }
    
    var attendeePaidAmount: Int {
        return _attendeePaidAmount
    }
    
    
    /*
     
     From Hasher Class you get HasherId, HasherNerdName
     
     */
    
    
    convenience init(attendeeInitId: String, attendeeInitDict: Dictionary<String, AnyObject>, attendeeInitTrailId: String, attendeeInitKennelId: String, attendeeAttendingInit: Bool) {
        self.init(hasherInitId: attendeeInitId, hasherInitDict: attendeeInitDict)
        //super._hasherId = attendeeInitId
        self._attendeeRelevantTrailId = attendeeInitTrailId
        self.attendeeAttending = attendeeAttendingInit
        
        if let attendeeInitHashNamesDict = attendeeInitDict["hasherHashNames"] as? Dictionary<String, String> {
            if let attendeeInitRelevantHashName1 = attendeeInitHashNamesDict.allKeysForValue(attendeeInitKennelId) as? [String] {
                if attendeeInitRelevantHashName1 != [] {
                    self._attendeeRelevantHashName = attendeeInitRelevantHashName1[0]
                } else {
                    if let attendeeInitRelevantHashName2 = attendeeInitHashNamesDict.allKeysForValue("Primary") as? [String] {
                        if attendeeInitRelevantHashName2 != [] {
                            self._attendeeRelevantHashName = attendeeInitRelevantHashName2[0]
                        } else {
                            self._attendeeRelevantHashName = "NFN ... yet"
                        }
                    }
                }
            }
        }
        
        if let attendeeTrailsInfoDict = attendeeInitDict["trailsAttended"] as? Dictionary<String, AnyObject> {
            if let attendeeCurrentTrailInfo = attendeeTrailsInfoDict[attendeeRelevantTrailId] as? Dictionary<String, AnyObject> {
                self._attendeePaidAmount = attendeeCurrentTrailInfo["hasherPaidTrailAmt"] as! Int
                self._attendeePaidNotes = attendeeCurrentTrailInfo["hasherPaidReducedReason"] as! String
                
            }
        }
    }
    
}