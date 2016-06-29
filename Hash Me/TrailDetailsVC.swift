//
//  TrailDetailsVC.swift
//  Hash Me
//
//  Created by Holly Klose on 5/13/16.
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
    var relevantHashName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadHasherDetails { () -> () in
//            print("trailHareNamesDict", self.trailHareNamesDict)
            self.updateTrailDetails()
        }
    }
    
    func downloadHasherDetails(completed: DownloadComplete) {
        
        
        DataService.ds.REF_HASHERS.observeEventType(.Value, withBlock: { snapshot in
            self.trailHareNamesDict = [:]
            if let hasherDict = snapshot.value as? Dictionary<String, AnyObject> {
 
                if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    for snap in snapshots {
                        
                        if let hasherDict2 = snap.value as? Dictionary<String, AnyObject> {
                            
                            for _ in hasherDict2 {
                                
                                if let hashIdsAndKennelHashNames = hasherDict2["hasherKennelsAndNames"] as? Dictionary<String, AnyObject> {
                                
                                
                                if hashIdsAndKennelHashNames[self.trails.trailKennelId] as? String == "primary" || hashIdsAndKennelHashNames[self.trails.trailKennelId] as? NSObject == true {
                                    self.relevantHashName = String(hasherDict2["hasherPrimaryHashName"]!)
                                    self.trailHareNamesDict[snap.key] = self.relevantHashName
                                } else {
                                    if hashIdsAndKennelHashNames[self.trails.trailKennelId] != nil {
                                    self.relevantHashName = String(hashIdsAndKennelHashNames[self.trails.trailKennelId]!)
                                    self.trailHareNamesDict[snap.key] = self.relevantHashName
                                    } else {
                                        self.relevantHashName = "Not a member of this kennel"
                                        self.trailHareNamesDict[snap.key] = self.relevantHashName
                                    }
                                }
                            }
                                else {
                                    self.relevantHashName = String(hasherDict2["hasherPrimaryHashName"]!)
                                    self.trailHareNamesDict[snap.key] = self.relevantHashName
                                }
                            }
                           
                    }
                    
                }
            }
            }
            completed()
            })
        
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
        
        specificTrailHares.text = ""
        specificTrailBagCar.text = ""
        for (key, value) in trails.trailHares {
            if value == "Hare" {
                specificTrailHares.text! += "\(trailHareNamesDict[key]!). "
            } else if value == "Bag Car" {
                specificTrailBagCar.text! += "\(trailHareNamesDict[key]!). "
            }
        }

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "trailRsvpList" {
            if let TrailAttendeesVC = segue.destinationViewController as? TrailAttendeesVC {
                    TrailAttendeesVC.trails = trails
            }
        }
    }
    
}



