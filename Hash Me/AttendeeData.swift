////
////  File.swift
////  Hash Me
////
////  Created by Eric Klose on 3/14/16.
////  Copyright © 2016 Eric Klose. All rights reserved.
////
//
//import Foundation
//import Firebase
//
//class Attendee: Hasher {
//    
//    private var _attendeeHashName: String!
//    private var _attendee_paid: Int!
//    private var _attendeeTrailId: String!
//
//    var attendeeHashName: String {
//        return _attendeeHashName
//    }
//    
//    var attendee_paid: Int {
//        return _attendee_paid
//    }
//    
//    var attendeeTrailId: String {
//        return _attendeeTrailId
//    }
//    
//    convenience init(hasher: String, attendeeInfoDict: Dictionary<String, AnyObject>) {
//        self.hasher = attendeeInfoDict.hasherID
//        
//        //self._attendeeKey = attendeeKey
//        
//        if let attendeeHashName = attendeeInfoDict["hasherHashName"]![0] as? String {
//            self._attendeeHashName = attendeeHashName
//        }
//        
//    }
//    
//}