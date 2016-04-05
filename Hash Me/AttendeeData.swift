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
    private var _attendeeVisitingTrail: Bool!
    private var _attendeeVisitingFrom: String!
    
    var attendeeAttending: Bool!
    
    var attendeeRelevantHashName: String {
        return _attendeeRelevantHashName
    }
    
    var attendeeRelevantTrailId: String {
        return _attendeeRelevantTrailId
    }
    
    var attendeePaidAmount: Int {
        if _attendeePaidAmount != nil {
            return _attendeePaidAmount
        } else {
            return 0
        }
    }
    
    var attendeePaidNotes: String {
        if _attendeePaidNotes != nil {
            return _attendeePaidNotes
        } else {
            return ""
        }
    }
    
    var attendeeVirginTrail: Bool {
        if _attendeeVirginTrail != nil {
            return _attendeeVirginTrail
        } else {
            return false
        }
    }
    
    var attendeeVirginSponsor: String {
        if _attendeeVirginSponsor != nil {
            return _attendeeVirginSponsor
        } else {
            return ""
        }
    }
    
    var attendeeVisitingTrail: Bool {
        if _attendeeVisitingTrail != nil {
            return _attendeeVisitingTrail
        } else {
            return false
        }
    }
    
    var attendeeVisitingFrom: String {
        if _attendeeVisitingFrom != nil {
            return _attendeeVisitingFrom
        } else {
            return ""
        }
    }
    
        /*
         
         From Hasher Class you get HasherId, HasherNerdName
         
         */
        
        
        convenience init(attendeeInitId: String, attendeeInitDict: Dictionary<String, AnyObject>, attendeeInitTrailId: String, attendeeInitKennelId: String, attendeeAttendingInit: Bool) {
            self.init(hasherInitId: attendeeInitId, hasherInitDict: attendeeInitDict)

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
                                self._attendeeRelevantHashName = ""
                            }
                        }
                    }
                }
            }
            
            if let attendeeTrailsInfoDict = attendeeInitDict["trailsAttended"] as? Dictionary<String, AnyObject> {
                if let attendeeCurrentTrailInfo = attendeeTrailsInfoDict[attendeeRelevantTrailId] as? Dictionary<String, AnyObject> {
                    
                    if let initPaid = attendeeCurrentTrailInfo["hasherPaidTrailAmt"] as? Int {
                        self._attendeePaidAmount = initPaid
                    }
                    
                    if let initPaidReducedReason = attendeeCurrentTrailInfo["hasherPaidReducedReason"] as? String {
                        self._attendeePaidNotes = initPaidReducedReason
                    }
                    
                    if let initIsVirgin = attendeeCurrentTrailInfo["hasherVirginTrail"] as? Bool {
                        self._attendeeVirginTrail = initIsVirgin
                    }
                    
                    if let initVirginSponsor = attendeeCurrentTrailInfo["hasherVirginSponsor"] as? String {
                        self._attendeeVirginSponsor = initVirginSponsor
                    }
                    
                    if let initVisitor = attendeeCurrentTrailInfo["hasherVisiting"] as? Bool {
                        self._attendeeVisitingTrail = initVisitor
                    }
                    
                    if let initVisitingFrom = attendeeCurrentTrailInfo["hasherVistingFrom"] as? String {
                        self._attendeeVisitingFrom = initVisitingFrom
                    }
                }
            }
        }
        
}