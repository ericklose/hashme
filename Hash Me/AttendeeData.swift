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
    private var _attendeeVirginTrail: Bool!
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
    
    var attendeePaidNotes: String {
        return _attendeePaidNotes
    }
    
    var attendeeVirginTrail: Bool {
        return _attendeeVirginTrail
    }
    
    var attendeeVirginSponsor: String {
        return _attendeeVirginSponsor
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
                
                if let initPaid = attendeeCurrentTrailInfo["hasherPaidTrailAmt"] as? Int {
                    self._attendeePaidAmount = initPaid
                    print("1: \(_attendeePaidAmount)")
                }
                
                if let initPaidReducedReason = attendeeCurrentTrailInfo["hasherPaidReducedReason"] as? String {
                    self._attendeePaidNotes = initPaidReducedReason
                    print("2: \(_attendeePaidNotes)")
                }
                
                if let initIsVirgin = attendeeCurrentTrailInfo["hasherVirginTrail"] as? Bool {
                    self._attendeeVirginTrail = initIsVirgin
                    print("3: \(_attendeeVirginTrail)")
                }
                
                //if let initVirginSponsor = attendeeCurrentTrailInfo["]
                
            }
        }
    }
    
}