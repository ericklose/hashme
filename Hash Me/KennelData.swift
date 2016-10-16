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
    
    fileprivate var _kennelId: String!
    fileprivate var _kennelName: String!
    fileprivate var _kennelDict: Dictionary<String, AnyObject>!
    fileprivate var _kennelDescription: String!
    fileprivate var _kennelLocation: String!
    fileprivate var _kennelMapLocation: String!
    fileprivate var _kennelCityAndRegion: String!
    fileprivate var _kennelSchedule: String!
    fileprivate var _kennelCountry: String!
    fileprivate var _kennelState: String!
    fileprivate var _kennelCity: String!
    fileprivate var _kennelPostalCode: String!
    fileprivate var _kennelMismanagement: Dictionary<String, AnyObject>!
    fileprivate var _kennelAdmins: Dictionary<String, AnyObject>!
    fileprivate var _kennelUrl: FIRDatabaseReference!
    fileprivate var _kennels: [KennelData]!
    
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
    
    var kennelDescription: String {
        if _kennelDescription == nil {
            return " "
        } else {
            return _kennelDescription
        }
    }
    
    var kennelCityAndRegion: String {
        if _kennelCityAndRegion == nil {
            return ""
        } else {
            return _kennelCityAndRegion
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
    
    var kennelState: String {
        if _kennelState == nil {
            return ""
        } else {
            return _kennelState
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
    
    var kennels: [KennelData] {
        return _kennels
    }
    
    
    func getKennelInfo(_ completed: @escaping DownloadComplete) {
        DataService.ds.REF_KENNELS.observe(.value, with: { snapshot in
            
            self._kennels = []
            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    if let kennelDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let kennelName = kennelDict["kennelName"] as? String
                        let kennel = KennelData(kennelInitId: key, kennelInitDict: kennelDict, kennelInitName: kennelName!)
                        self._kennels.append(kennel)
                    }
                }
            }
            completed()
        })
    }
    
    func kennelSetName(_ kennelId: String, newKennelName: String) {
        if newKennelName == "" {
            _kennelUrl.child("kennelName").removeValue()
        } else {
            _kennelUrl.updateChildValues(["kennelName" : newKennelName])
        }
    }
    
    func kennelSetDescription(_ kennelId: String, newKennelDescription: String) {
        if newKennelDescription == "" {
            _kennelUrl.child("kennelDescription").removeValue()
        } else {
            _kennelUrl.updateChildValues(["kennelDescription" : newKennelDescription])
        }
    }
    
    func kennelSetSchedule(_ kennelId: String, newKennelSchedule: String) {
        if newKennelSchedule == "" {
            _kennelUrl.child("kennelSchedule").removeValue()
        } else {
            _kennelUrl.updateChildValues(["kennelSchedule" : newKennelSchedule])
        }
    }
    
    func kennelSetCountry(_ kennelId: String, newKennelCountry: String) {
        if newKennelCountry == "" {
            _kennelUrl.child("kennelCountry").removeValue()
        } else {
            _kennelUrl.updateChildValues(["kennelCountry" : newKennelCountry])
        }
    }
    
    func kennelSetState(_ kennelId: String, newKennelState: String) {
        if newKennelState == "" {
            _kennelUrl.child("kennelState").removeValue()
        } else {
            _kennelUrl.updateChildValues(["kennelState" : newKennelState])
        }
    }
    
    func kennelSetCity(_ kennelId: String, newKennelCity: String) {
        if newKennelCity == "" {
            _kennelUrl.child("kennelCity").removeValue()
        } else {
            _kennelUrl.updateChildValues(["kennelCity" : newKennelCity])
        }
    }
    
    func kennelSetPostalCode(_ kennelId: String, newKennelPostalCode: String) {
        if newKennelPostalCode == "" {
            _kennelUrl.child("kennelPostalCode").removeValue()
        } else {
            _kennelUrl.updateChildValues(["kennelPostalCode" : newKennelPostalCode])
        }
    }
    
    func kennelSetAdminStatus(_ kennelId: String, hasherId: String, newKennelAdminStatus: String) {
        if newKennelAdminStatus == "" {
            _kennelUrl.child("kennelAdmins").child(hasherId).removeValue()
        } else if newKennelAdminStatus == "full" || newKennelAdminStatus == "trail" {
            _kennelUrl.child("kennelAdmins").updateChildValues([hasherId : newKennelAdminStatus])
        }
    }
    
    func kennelSetMismanagementStatus(_ kennelId: String, hasherId: String, newKennelMismanStatus: String) {
        if newKennelMismanStatus == "" {
            _kennelUrl.child("kennelMismanagement").child(hasherId).removeValue()
        } else {
            _kennelUrl.child("kennelMismanagement").updateChildValues([hasherId : newKennelMismanStatus])
        }
    }
    
    init(isFake: String) {
        print("Fake Kennel Initializer (figure out a better way to do this sometime): ", isFake)
    }
    
    init (kennelInitId: String, kennelInitDict: Dictionary<String, AnyObject>, kennelInitName: String) {
        self._kennelId = kennelInitId
        self._kennelDict = kennelInitDict
        
        if let kennelInitName = kennelInitDict["kennelName"] as? String {
            self._kennelName = kennelInitName
        }
        
        if let kennelInitDescription = kennelInitDict["kennelDescription"] as? String {
            self._kennelDescription = kennelInitDescription
        }
        
        if let kennelInitSchedule = kennelInitDict["kennelSchedule"] as? String {
            self._kennelSchedule = kennelInitSchedule
        }
        
        if let kennelInitState = kennelInitDict["kennelState"] as? String {
            self._kennelState = kennelInitState
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
        
        if _kennelCountry != nil {
            if _kennelLocation != nil {
            self._kennelLocation = self._kennelLocation + ", " + self._kennelCountry
            if self._kennelCountry != "USA" {
                self._kennelCityAndRegion = self._kennelCountry
            }
            } else if _kennelLocation == nil {
                self._kennelLocation = self._kennelCountry
            }
        }
        
        if _kennelPostalCode != nil {
            self._kennelLocation = self._kennelPostalCode + ", " + self._kennelLocation
        }
        if _kennelState != nil {
            self._kennelLocation = self._kennelState + ", " + self._kennelLocation
            if self._kennelCountry == "USA" {
                self._kennelCityAndRegion = self._kennelState
            }
        }
        if _kennelCity != nil {
            self._kennelLocation = self._kennelCity + ", " + self._kennelLocation
            self._kennelCityAndRegion = self._kennelCity + ", " + self._kennelCityAndRegion
        }
        
        self._kennelUrl = DataService.ds.REF_KENNELS.child(_kennelId)
    }
    
    
}
