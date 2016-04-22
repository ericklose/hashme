//
//  KennelData.swift
//  Hash Me
//
//  Created by Eric Klose on 3/16/16.
//  Copyright © 2016 Eric Klose. All rights reserved.
//

import Foundation
import Firebase

class KennelData {
    
    private var _kennelId: String!
    private var _kennelName: String!
    private var _kennelDict: Dictionary<String, AnyObject>!
    private var _kennelLocation: String!
    private var _kennelSchedule: String!
    private var _kennelCountry: String!
    private var _kennelUsState: String!
    private var _kennelMismanagement: Dictionary<String, AnyObject>!
    private var _kennelAdmins: Dictionary<String, AnyObject>!
    
    var kennelId: String {
        return _kennelId
    }
    
    var kennelMismanagement: Dictionary<String, AnyObject> {
        return _kennelMismanagement
    }
    
    var kennelAdmins: Dictionary<String, AnyObject>! {
        return _kennelAdmins
    }
    
    var kennelCountry: String {
        if _kennelCountry == nil {
            return "unknown"
        } else {
            return _kennelCountry
        }
    }
    
    var kennelUsState: String {
        if _kennelUsState == nil {
            return ""
        } else {
            return _kennelUsState
        }
    }
    
    var kennelLocation: String {
        if _kennelLocation == nil {
            return "unknown location"
        } else {
            return _kennelUsState + ", " + _kennelCountry
        }
    }
    
    var kennelSchedule: String {
        if _kennelSchedule == nil {
            return "unknown schedule"
        } else {
            return _kennelSchedule
        }
    }
    
    var kennelName: String {
        return _kennelName
    }
    
    var kennelDict: Dictionary<String, AnyObject> {
        return _kennelDict
    }
    
    init (kennelInitId: String, kennelInitDict: Dictionary<String, AnyObject>, kennelInitName: String) {
        self._kennelId = kennelInitId
        self._kennelDict = kennelInitDict
        
        if let kennelInitName = kennelInitDict["kennelName"] as? String {
            self._kennelName = kennelInitName
        }
        
        if let kennelInitSchedule = kennelInitDict["kennelSchedule"] as? String {
            self._kennelSchedule = kennelInitSchedule
        }
        
        if let kennelInitUsState = kennelInitDict["kennelUsState"] as? String {
            self._kennelUsState = kennelInitUsState
        }
        
        if let kennelInitCountry = kennelInitDict["kennelCountry"] as? String {
            self._kennelCountry = kennelInitCountry
        }
        
        if let kennelInitSchedule = kennelInitDict["kennelSchedule"] as? String {
            self._kennelSchedule = kennelInitSchedule
        }
        
        if let kennelInitMismanagement = kennelInitDict["kennelMismanagement"] as? Dictionary<String, AnyObject> {
            self._kennelMismanagement = kennelInitMismanagement
        }
        
        if let kennelInitAdmins = kennelInitDict["kennelAdmins"] as? Dictionary<String, AnyObject> {
            self._kennelAdmins = kennelInitAdmins
        }
        
        if self._kennelCountry == "USA" {
            self._kennelLocation = _kennelUsState + ", " + _kennelCountry
        } else if self._kennelUsState == nil {
            self._kennelLocation = _kennelCountry
        } else {
            self._kennelLocation = "location unknown"
        }
        
    }
    
    
}