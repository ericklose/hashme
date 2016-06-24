//
//  TrailListData.swift
//  Hash Me
//
//  Created by Eric Klose on 6/24/16.
//  Copyright © 2016 Eric Klose. All rights reserved.
//

import Foundation
import Firebase

class TrailListData {

    private var _trailList: [TrailData] = []
    
    var trailList: [TrailData] {
        return _trailList
    }
    
    func generateTrailList(completed: DownloadComplete) {
        DataService.ds.REF_TRAILS.observeEventType(.Value, withBlock: { snapshot in
            
            self._trailList = []
            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    if let trailDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let trail = TrailData(trailKey: key, dictionary: trailDict)
                        self._trailList.append(trail)
                    }
                }
            }
            completed()
        })

        }
    }
    