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
            print("snapshot:\(snapshot.value)")
            
            if let generalDict = snapshot.value as? Dictionary<String, AnyObject> {
                let attendeeArray = generalDict["trailAttendees"] as? Dictionary<String, AnyObject>
                print("keyarray:\(attendeeArray)")
                
                if attendeeArray != nil {
                    //not comfortable with exclamation point below
                    //let person: Attendee
                    for person in attendeeArray! {
                        if let personDict = person as? Dictionary<String, AnyObject> {
                            let paid = personDict["paid"]
                            print("paid: \(paid)")
                            //  attendeeKeyArray = [Attendee](attendeeArray!.keys)
                        }
                        //
                        //            self.attendees = []
                        if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                            for snap in snapshots {
                                print("SNAP: \(snap)")
                                //                    if let attendeeDict = snap.value as? Dictionary<String, AnyObject> {
                                //                        let key = snap.key
                                //                        let attendee = Attendee(dictionary: attendeeDict)
                                //                        self.attendees.append(attendee)
                            }
                        }
                    }
                }
                //            self.trailAttendeeTableView.reloadData()
            }
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



