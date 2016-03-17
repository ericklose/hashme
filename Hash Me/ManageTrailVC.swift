//
//  ManageTrailVC.swift
//  Hash Me
//
//  Created by Eric Klose on 3/13/16.
//  Copyright © 2016 Eric Klose. All rights reserved.
//

import UIKit
import Firebase

class ManageTrailVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var trailAttendeeTableView: UITableView!
    
    @IBOutlet weak var specificTrailDate: UILabel!
    @IBOutlet weak var specificTrailKennel: UILabel!
    @IBOutlet weak var specificTrailStartLocation: UILabel!
    @IBOutlet weak var specificTrailHares: UILabel!
    @IBOutlet weak var specificTrailDescription: UILabel!
    
    var trails: TrailData!
    var attendees = [Attendee]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trailAttendeeTableView.delegate = self
        trailAttendeeTableView.dataSource = self
        
        let thisCurrentTrail = Firebase(url: "\(DataService.ds.REF_TRAILS)").childByAppendingPath(trails.trailKey)
        
        updateTrailDetails()
        
        thisCurrentTrail.observeEventType(.Value, withBlock: { snapshot in
            //print("Trail Snapshot:\(snapshot.value)")
            
            if let generalDict = snapshot.value as? Dictionary<String, AnyObject> {
                let attendeeDict = generalDict["trailAttendees"] as? Dictionary<String, AnyObject>
                print("ATTENDEE DICT:\(attendeeDict)")
                let attendeeKeys = [String](attendeeDict!.keys)
                print("Just the keys are: \(attendeeKeys)")
                
                if attendeeDict != nil {
                    for var x = 0; x < attendeeDict!.count; x++ {
                        print("PRINT THE KEY \(attendeeKeys[x])")
                       let testerVar = attendeeDict![attendeeKeys[x]]
                        print("DGSLDGJSN \(testerVar)")
                        print(testerVar!["paid"])
                        if let paidHasher = attendeeDict!["\(attendeeKeys[x])"] as? [Dictionary<String, AnyObject>] {
                        print(attendeeKeys[x])
                            print("test")
                            let paid1 = attendeeDict!["\(attendeeKeys[x])/paid"]
                            print("PAID1: \(paid1)")
                            let paid2 = attendeeDict!["paid"]
                            print("PAID2: \(paid2)")
                        print("PaidHASHER: \(paidHasher)")
//                        let paid3 = attendeeDict[attendeeKeys]["paid"]
//                        print("PAID3: \(paid3)")
                        }
                        }
                    }
                
                }
                //            self.trailAttendeeTableView.reloadData()
            })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateTrailDetails() {
        specificTrailDate.text = trails.trailDate
        specificTrailKennel.text = trails.trailHares
        specificTrailStartLocation.text = trails.trailStartLocation
        specificTrailHares.text = trails.trailHares
        specificTrailDescription.text = trails.trailDescription
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //        let attendeeList = self.attendeeKeyArray[indexPath.row]
        //        
        //        if let cell = tableView.dequeueReusableCellWithIdentifier("trailAttendeeCell") as? AttendeeCell {
        //            cell.configureCell(attendee)
        //            return cell
        //        } else {
        //            return AttendeeCell()
        //        }
        
        return AttendeeCell()
    }
    
}



