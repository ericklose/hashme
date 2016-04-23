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
    
    func attendeeSetIsPresent(attendeeId: String, trailId: String, attendeeIsPresent: Bool) {
        if attendeeIsPresent == true {
            _attendeeHasherUrl.updateChildValues(["hasherAttendedTrail" : attendeeIsPresent])
            _attendeeTrailUrl.updateChildValues(["trailAttendeePresent" : attendeeIsPresent])
            _attendeeKennelUrl.updateChildValues(["trailAttendeePresent" : attendeeIsPresent])
        } else if attendeeIsPresent == false {
            _attendeeHasherUrl.removeValue()
            _attendeeTrailUrl.removeValue()
            _attendeeKennelUrl.removeValue()
        }
    }
    
    func attendeeSetPaidAmt(attendeeId: String, trailId: String, attendeePaid: Int) {
        _attendeeHasherUrl.updateChildValues(["hasherPaidTrailAmt" : attendeePaid])
        _attendeeTrailUrl.updateChildValues(["trailAttendeePaidAmt" : attendeePaid])
        _attendeeKennelUrl.updateChildValues(["trailAttendeePaidAmt" : attendeePaid])
    }
    
    func attendeeSetPaidReducedReason(attendeeId: String, trailId: String, attendeePaidReducedReason: String) {
        if attendeePaidReducedReason == "" {
            _attendeeHasherUrl.childByAppendingPath("hasherPaidReducedReason").removeValue()
            _attendeeTrailUrl.childByAppendingPath("trailAttendeePaidReducedReason").removeValue()
            _attendeeKennelUrl.childByAppendingPath("trailAttendeePaidReducedReason").removeValue()
        } else {
            _attendeeHasherUrl.updateChildValues(["hasherPaidReducedReason" : attendeePaidReducedReason])
            _attendeeTrailUrl.updateChildValues(["trailAttendeePaidReducedReason" : attendeePaidReducedReason])
            _attendeeKennelUrl.updateChildValues(["trailAttendeePaidReducedReason" : attendeePaidReducedReason])
        }
    }
    
    func attendeeSetNotPaid(attendeeId: String, trailId: String) {
        _attendeeHasherUrl.childByAppendingPath("hasherPaidTrailAmt").removeValue()
        _attendeeTrailUrl.childByAppendingPath("trailAttendeePaidAmt").removeValue()
        _attendeeKennelUrl.childByAppendingPath("trailAttendeePaidAmt").removeValue()
        _attendeeHasherUrl.childByAppendingPath("hasherPaidReducedReason").removeValue()
        _attendeeTrailUrl.childByAppendingPath("trailAttendeePaidReducedReason").removeValue()
        _attendeeKennelUrl.childByAppendingPath("trailAttendeePaidReducedReason").removeValue()
    }
    
    //STILL MISSING VIRGIN & VISITOR UPDATES
    
    
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
        
        self._attendeeHasherUrl = DataService.ds.REF_HASHERS.childByAppendingPath(self.hasherId).childByAppendingPath("trailsAttended").childByAppendingPath(self._attendeeRelevantTrailId)
        self._attendeeTrailUrl = DataService.ds.REF_TRAILS.childByAppendingPath(self._attendeeRelevantTrailId).childByAppendingPath("trailAttendees").childByAppendingPath(self.hasherId)
        self._attendeeKennelUrl = DataService.ds.REF_KENNELS.childByAppendingPath(attendeeInitKennelId).childByAppendingPath("kennelTrails").childByAppendingPath(self._attendeeRelevantTrailId).childByAppendingPath("trailAttendees").childByAppendingPath(self.hasherId)
        
    }
}