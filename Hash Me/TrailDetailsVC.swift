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
        
        self.updateTrailDetails()
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
            let hareInitDict = ["attendeeIsHare" : true, "attendeeIsAdmin" : true]
            let hare = Attendee(attendeeInitId: key, attendeeInitDict: hareInitDict as Dictionary<String, AnyObject>, attendeeInitTrailId: trails.trailKey, attendeeInitKennelId: trails.trailKennelId, attendeeAttendingInit: true, attendeeInitTrailHashCash: trails.trailHashCash)
            hare.getRelevantHashName(key, kennelId: trails.trailKennelId) { () -> () in
                if value == "Hare" {
                    if self.specificTrailHares.text == "" {
                        self.specificTrailHares.text! += "\(hare.attendeeRelevantHashName)"
                    } else {
                        self.specificTrailHares.text! += ", \(hare.attendeeRelevantHashName)"
                    }
                } else if value == "Bag Car" {
                    self.specificTrailBagCar.text! += "\(hare.attendeeRelevantHashName) "
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "trailRsvpList" {
            if let TrailAttendeesVC = segue.destination as? TrailAttendeesVC {
                TrailAttendeesVC.trails = trails
            }
        } else if segue.identifier == "editTrail" {
//            Well shit, we never built an Edit Trail page
            let alertController = UIAlertController(title: "There's no trail edit yet", message: "There's a lot of shit to build. Get of my back!", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
                print("you have pressed the Cancel button");
            }
            alertController.addAction(cancelAction)
            
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                print("you have pressed OK button");
            }
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true, completion:nil)
        }
    }
    
}



