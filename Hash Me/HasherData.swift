//
//  HasherData.swift
//  Hash Me
//
//  Created by Holly Klose on 3/13/16.
//  Copyright © 2016 Eric Klose. All rights reserved.
//

import Foundation
import Firebase

class Hasher {
    
    private var _hasherId: String!
    private var _hasherNerdName: String!
    private var _hasherHashNames: Dictionary<String, AnyObject>!
    private var _hasherKennelMemberships: Dictionary<String, AnyObject>!
    private var _hasherTrailsAttended: Array<String>?
    private var _hasherTrailsHared: Array<String>?
    private var _kennelInitDict: Dictionary<String, AnyObject>!
    private var _hasherPrimaryHashName: String!
    private var _hasherPrimaryKennel: String!
    
    var kennelAndNameDict: Dictionary<String, String>!
    
    var hasherId: String {
        return _hasherId
    }
    
    var hasherNerdName: String {
        if _hasherNerdName != nil {
        return _hasherNerdName
        }
        return "Incognito"
    }
    
    var hasherHashNames: Dictionary<String, AnyObject> {
        return _hasherHashNames
    }
    
    var hasherKennelMemberships: Dictionary<String, AnyObject> {
        return _hasherKennelMemberships
    }
  
    var hasherTrailsAttended: Array<String>? {
        return _hasherTrailsAttended
        }
    
    var hasherTrailsHared: Array<String>? {
        return _hasherTrailsHared
    }
    
    var kennelInitDict: Dictionary<String, AnyObject> {
        return _kennelInitDict
    }
    
    var hasherPrimaryHashName: String {
        if _hasherPrimaryHashName != nil {
            return _hasherPrimaryHashName
        } else {
            return "Has no primary hash name"
        }
    }
    
    var hasherPrimaryKennel: String {
        if _hasherPrimaryKennel != nil {
        return _hasherPrimaryKennel
        } else {
            return "Has no primary kennel"
        }
    }
    

    
    
    init (hasherInitId: String, hasherInitDict: Dictionary<String, AnyObject>) {
        self._hasherId = hasherInitId
        
        if let hasherInitNerdName = hasherInitDict["hasherNerdName"] as? String {
            self._hasherNerdName = hasherInitNerdName
        }
        
        if let hasherPrimaryHashName = hasherInitDict["hasherPrimaryHashName"] as? String {
            self._hasherPrimaryHashName = hasherPrimaryHashName
        }
        
        if let hasherPrimaryKennel = hasherInitDict["hasherPrimaryKennel"] as? String {
            self._hasherPrimaryKennel = hasherPrimaryKennel
        }
        
     //   print("XXX: \(hasherInitDict)")
        
    }
    
    func downloadHasherDetails (completed: DownloadComplete) {
        DataService.ds.REF_HASHER_CURRENT.observeEventType(.Value, withBlock: { snapshot in
            //  print("snapshotY: \(snapshot)")
            
            if var hasherDict = snapshot.value as? Dictionary<String, AnyObject>{
                DataService.ds.REF_KENNELS.observeEventType(.Value, withBlock: { snapshot in
                    if let kennelDict = snapshot.value as? Dictionary<String, AnyObject> {
                        if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                            
                            for snap in snapshots {
                                
                                if let kennelDict2 = snap.value as? Dictionary<String, AnyObject> {
                                    let key = snap.key
                                    let name = kennelDict2["name"]!
                                    
                                    self.kennelAndNameDict[key] = (name as! String)
                                }
                            }
                            //                                print("kennelandnamedict: \(self.kennelAndNameDict)")
                        }
                    }
                    
                    hasherDict["addedKennelDict"] = self.kennelAndNameDict
                    //      print("hasherDictNew: \(hasherDict)")
                })
                
                let hasher = Hasher(hasherInitId: KEY_UID, hasherInitDict: hasherDict)
                print("1:\(hasher.hasherPrimaryHashName)")
                
            }
         //   print("2:\(hasher.hasherPrimaryHashName)")
            completed()
            
        })
    }
    
}
