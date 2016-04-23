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
    private var _attendeeVisitingFrom: String!
    private var _attendeeTrailHashCash: Int!
    private var _attendeeHasherUrl: Firebase!
    private var _attendeeTrailUrl: Firebase!
    private var _attendeeKennelUrl: Firebase!
    
    var attendeeAttending: Bool!
    
    var attendeeRelevantHashName: String {
        if _attendeeRelevantHashName != nil {
            return _attendeeRelevantHashName
        } else {
            return ""
        }
    }
    
    var attendeeTrailHashCash: Int {
        if _attendeeTrailHashCash != nil {
            return _attendeeTrailHashCash
        } else {
            return 0
        }
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
    
    var attendeeVirginSponsor: String {
        if _attendeeVirginSponsor != nil {
            return _attendeeVirginSponsor
        } else {
            return ""
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
    
    
    convenience init(attendeeInitId: String, attendeeInitDict: Dictionary<String, AnyObject>, attendeeInitTrailId: String, attendeeInitKennelId: String, attendeeAttendingInit: Bool, attendeeInitTrailHashCash: Int) {
        self.init(hasherInitId: attendeeInitId, hasherInitDict: attendeeInitDict)
        
        self._attendeeRelevantTrailId = attendeeInitTrailId
        self.attendeeAttending = attendeeAttendingInit
        self._attendeeTrailHashCash = attendeeInitTrailHashCash
        
        if let attendeeInitHashNamesDict = attendeeInitDict["hasherKennelsAndNames"] as? Dictionary<String, AnyObject> {
            if let attendeeNameForThisKennel = attendeeInitHashNamesDict[attendeeInitKennelId] {
                if attendeeNameForThisKennel as! NSObject == true {
                    self._attendeeRelevantHashName = attendeeInitDict["hasherPrimaryHashName"] as! String
                } else if attendeeNameForThisKennel as! String == "primary" {
                    self._attendeeRelevantHashName = attendeeInitDict["hasherPrimaryHashName"] as! String
                } else {
                    self._attendeeRelevantHashName = attendeeNameForThisKennel as! String
                }
            } else {
                self._attendeeRelevantHashName = attendeeInitDict["hasherPrimaryHashName"] as! String
            }
        } else {
            self._attendeeRelevantHashName = attendeeInitDict["hasherPrimaryHashName"] as! String
        }
        
        if let attendeeTrailsInfoDict = attendeeInitDict["trailsAttended"] as? Dictionary<String, AnyObject> {
            if let attendeeCurrentTrailInfo = attendeeTrailsInfoDict[attendeeRelevantTrailId] as? Dictionary<String, AnyObject> {
                
                if let initPaid = attendeeCurrentTrailInfo["hasherPaidTrailAmt"] as? Int {
                    self._attendeePaidAmount = initPaid
                }
                
                if let initPaidReducedReason = attendeeCurrentTrailInfo["hasherPaidReducedReason"] as? String {
                    self._attendeePaidNotes = initPaidReducedReason
                }
                
                if let initVirginSponsor = attendeeCurrentTrailInfo["hasherVirginSponsor"] as? String {
                    self._attendeeVirginSponsor = initVirginSponsor
                }
                
                if let initVisitingFrom = attendeeCurrentTrailInfo["hasherVisitingFrom"] as? String {
                    self._attendeeVisitingFrom = initVisitingFrom
                }
            }
        }
        
        self._attendeeHasherUrl = DataService.ds.REF_HASHERS.childByAppendingPath(hasher.hasherId)
        self._attendeeTrailUrl = DataService.ds.REF_TRAILS.childByAppendingPath(_attendeeRelevantTrailId)
        self._attendeeKennelUrl = DataService.ds.REF_KENNELS.childByAppendingPath("trailAttendees").childByAppendingPath(_attendeeRelevantTrailId)

    }
}