//
//  TrailData.swift
//  Hash Me
//
//  Created by Eric Klose on 3/12/16.
//  Copyright © 2016 Eric Klose. All rights reserved.
//

import Foundation
import Alamofire
import Firebase

class TrailData {
    
    private var _trailDate: String!
    private var _trailKennel: String!
    private var _trailHares: String!
    private var _trailStartLocation: String!
    private var _trailDescription: String!
    
    var trailDate: String {
        return _trailDate
    }
    
    var trailKennel: String {
        return _trailKennel
    }
    
    var trailHares: String {
        return _trailHares
    }
    
    var trailStartLocation: String {
        return _trailStartLocation
    }
    
    var trailDescription: String {
        return _trailDescription
    }
    
    
    init(trailDate: String, trailKennel: String) {
        
    }
    
}
