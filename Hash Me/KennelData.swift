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
    
    var kennelId: String {
        return _kennelId
    }
    
    var kennelName: String {
        return _kennelName
    }
    
    init (kennelInitId: String, kennelInitDict: Dictionary<String, AnyObject>, kennelInitName: String) {
        self._kennelId = kennelInitId
        
        if let kennelInitName = kennelInitDict["name"] as? String {
            self._kennelName = kennelInitName
            print("kennelinitnamefromkenneldata: \(kennelInitName)")
        }
    }
    
    
}