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
    
    var kennelId: String {
        return _kennelId
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
        print("kennelDict: \(kennelInitDict)")
        self._kennelId = kennelInitId
        self._kennelDict = kennelInitDict
        
        if let kennelInitName = kennelInitDict["name"] as? String {
            self._kennelName = kennelInitName
            print("name: \(self._kennelName)")
        }
        
        if let kennelInitSchedule = kennelInitDict["kennelSchedule"] as? String {
            self._kennelSchedule = kennelInitSchedule
            
            print("schedule: \(self._kennelSchedule)")
        }
        
        if let kennelInitUsState = kennelInitDict["kennelUsState"] as? String {
            self._kennelUsState = kennelInitUsState
            
            print("state: \(self._kennelUsState)")
        }
        
        if let kennelInitCountry = kennelInitDict["kennelCountry"] as? String {
            self._kennelCountry = kennelInitCountry
            
            print("country: \(self._kennelCountry)")
        }
        
        if self._kennelCountry == "USA" {
            self._kennelLocation = _kennelUsState + ", " + _kennelCountry
            
            print("loc1: \(self._kennelLocation)")
        } else if self._kennelUsState == nil {
            self._kennelLocation = _kennelCountry
            
            print("loc2: \(self._kennelLocation)")
        } else {
            self._kennelLocation = "location unknown"
            
            print("loc3: \(self._kennelLocation)")
        }
        
    }
    
    
}