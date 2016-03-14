//
//  File.swift
//  Hash Me
//
//  Created by Eric Klose on 3/14/16.
//  Copyright © 2016 Eric Klose. All rights reserved.
//

import Foundation
import Firebase

class Attendee: Hasher {
    
    private var _paid_full: Bool!
    private var _attendeeTrailId: String!
    
    var paid_full: Bool {
        return _paid_full
    }
    
    var attendeeTrailId: String {
        return _attendeeTrailId
    }
    
//    convenience init(name: String, attended: String) {
//        self.init(hasherNerdName: name)
//       _attendeeTrailId = attended
//    }
    
    
}