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
        if _attendeeRelevantHashName != nil {
            return _attendeeRelevantHashName
        } else {
            return "No F'ing Name"
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
        // print("fulldict: \(attendeeInitDict)")
        
        //ALL OF THE NAME STUFF NEEDS REVIEW ONCE WE MIGRATE MORE PEOPLE TO HOLLY S NEW STRUCTURE
        if let attendeeInitHashNamesDict = attendeeInitDict["hasherKennelsAndNames"] as? Dictionary<String, AnyObject> {
            if let attendeeNameForThisKennel = attendeeInitHashNamesDict[attendeeInitKennelId] {
                if attendeeNameForThisKennel as! NSObject == true {
                    print("name source 1")
                    self._attendeeRelevantHashName = attendeeInitDict["hasherPrimaryHashName"] as! String
                } else if attendeeNameForThisKennel as! String == "primary" {
                    print("name source 2")
                    self._attendeeRelevantHashName = attendeeInitDict["hasherPrimaryHashName"] as! String
                } else {
                    print("name source 3")
                    self._attendeeRelevantHashName = attendeeNameForThisKennel as! String
                }
            } else {
                print("name source 4")
                self._attendeeRelevantHashName = attendeeInitDict["hasherPrimaryHashName"] as! String
            }
        } else {
            print("name source 5")
            self._attendeeRelevantHashName = attendeeInitDict["hasherPrimaryHashName"] as! String
        }
        print("relevant name: \(self._attendeeRelevantHashName)")
        
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