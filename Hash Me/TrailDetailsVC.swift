//
//  ManageTrailVC.swift (duplicated from eric's old VC. this is now TrailDetailsVC)
//  Hash Me
//
//  Created by Eric Klose on 3/13/16.
//  Copyright © 2016 Eric Klose. All rights reserved.
//

import UIKit
import Firebase

class TrailDetailsVC: UIViewController {
    
    //Outlets for the trail info
    @IBOutlet weak var specificTrailDate: UILabel!
    @IBOutlet weak var specificTrailKennel: UILabel!
    @IBOutlet weak var specificTrailStartLocation: UILabel!
    @IBOutlet weak var specificTrailHares: UILabel!
    @IBOutlet weak var specificTrailDescription: UILabel!
    @IBOutlet weak var specificTrailTitle: UILabel!
    @IBOutlet weak var specificTrailBagCar: UILabel!
    @IBOutlet weak var specificHashCash: UILabel!
    
    var trails: TrailData!

    var trailHareNamesDict: Dictionary<String, String> = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataService.ds.REF_HASHERS.observeEventType(.Value, withBlock: { snapshot in
            self.trailHareNamesDict = [:]
            
            if let hasherDict = snapshot.value as? Dictionary<String, String> {
                
                if let hashNamesAndKennels = hasherDict["hasherKennelsAndNames"] as? Dictionary<String, AnyObject> {
                    for hasher in hasherDict {
                        if hashNamesAndKennels[self.trails.trailKennelId] as? String == "primary" || hashNamesAndKennels[self.trails.trailKennelId] as? NSObject == true {
                            let relevantHashName = hasherDict["hasherPrimaryHashName"]
                        } else {
                            let relevantHashName = hashNamesAndKennels[snapshot.key]
                        }
                        
                    }
                    
                  //  self.kennelMembershipIds = [String](self.kennelAndHashNameDecodeDict.keys)
                    
                }
                
            }
            
            })

        
        updateTrailDetails()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateTrailDetails() {
        
        specificTrailDate.text = trails.trailDate
        specificTrailKennel.text = trails.trailKennelName
        specificTrailStartLocation.text = trails.trailStartLocation
        specificTrailDescription.text = trails.trailDescription
        specificTrailTitle.text = trails.trailTitle
        specificHashCash.text = "$\(trails.trailHashCash)"
        
        
        
        //specificTrailHares.text = trails.trailHares
        //bag car
    }
    
}



