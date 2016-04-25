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
    private var _kennelMapLocation: String!
    private var _kennelCity: String!
    private var _kennelPostalCode: String!
    private var _kennelMismanagement: Dictionary<String, AnyObject>!
    private var _kennelAdmins: Dictionary<String, AnyObject>!
    private var _kennelUrl: Firebase!
    
    var kennelId: String {
        return _kennelId
    }
    
    var kennelMismanagement: Dictionary<String, AnyObject> {
        return _kennelMismanagement
    }
    
    var kennelAdmins: Dictionary<String, AnyObject>! {
        return _kennelAdmins
    }
    
    var kennelCity: String {
        if _kennelCity == nil {
            return "unknown"
        } else {
            return _kennelCity
        }
    }
    
    var kennelPostalCode: String {
        if _kennelPostalCode == nil {
            return "unknown"
        } else {
            return _kennelPostalCode
        }
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
            return _kennelLocation
        }
    }
    
    var kennelMapLocation: String {
        if _kennelMapLocation == nil {
            return "map location not set"
        } else {
            return _kennelMapLocation
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
    
    func kennelSetName(kennelId: String, newKennelName: String) {
        if newKennelName == "" {
            _kennelUrl.childByAppendingPath("kennelName").removeValue()
        } else {
            _kennelUrl.updateChildValues(["kennelName" : newKennelName])
        }
    }
    
    func kennelSetSchedule(kennelId: String, newKennelSchedule: String) {
        if newKennelSchedule == "" {
            _kennelUrl.childByAppendingPath("kennelSchedule").removeValue()
        } else {
            _kennelUrl.updateChildValues(["kennelSchedule" : newKennelSchedule])
        }
    }
    
    func kennelSetCountry(kennelId: String, newKennelCountry: String) {
        if newKennelCountry == "" {
            _kennelUrl.childByAppendingPath("kennelCountry").removeValue()
        } else {
            _kennelUrl.updateChildValues(["kennelCountry" : newKennelCountry])
        }
    }
    
    func kennelSetUsState(kennelId: String, newKennelUsState: String) {
        if newKennelUsState == "" {
            _kennelUrl.childByAppendingPath("kennelUsState").removeValue()
        } else {
            _kennelUrl.updateChildValues(["kennelUsState" : newKennelUsState])
        }
    }
    
    func kennelSetCity(kennelId: String, newKennelCity: String) {
        if newKennelCity == "" {
            _kennelUrl.childByAppendingPath("kennelCity").removeValue()
        } else {
            _kennelUrl.updateChildValues(["kennelCity" : newKennelCity])
        }
    }
    
    func kennelSetPostalCode(kennelId: String, newKennelPostalCode: String) {
        if newKennelPostalCode == "" {
            _kennelUrl.childByAppendingPath("kennelPostalCode").removeValue()
        } else {
            _kennelUrl.updateChildValues(["kennelPostalCode" : newKennelPostalCode])
        }
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
        
        if let kennelInitMapLocation = kennelInitDict["kennelMapLocation"] as? String {
            self._kennelMapLocation = kennelInitMapLocation
        }
        
        if let kennelInitCity = kennelInitDict["kennelCity"] as? String {
            self._kennelCity = kennelInitCity
        }
        
        if let kennelInitPostalCode = kennelInitDict["kennelPostalCode"] as? String {
            self._kennelPostalCode = kennelInitPostalCode
        }
        
        //if let kennelInitLocation = kennelInitDict["kennelLocation"] as? String {
        
        if _kennelCountry != nil {
            self._kennelLocation = self._kennelCountry
        }
        if _kennelPostalCode != nil {
            self._kennelLocation = self._kennelPostalCode + ", " + _kennelLocation
        }
        if _kennelUsState != nil {
            self._kennelLocation = self._kennelUsState + ", " + _kennelLocation
        }
        if _kennelCity != nil {
            self._kennelLocation = self._kennelCity + ", " + _kennelLocation
        }
        
        self._kennelUrl = DataService.ds.REF_KENNELS.childByAppendingPath(_kennelId)
    }
    
    
}