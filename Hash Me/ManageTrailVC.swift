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
    var attendees = [Hasher]()
    
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
                        let attendingHasher = Firebase(url: "\(DataService.ds.REF_HASHERS)").childByAppendingPath(attendeeKeys[x])
                        
                        attendingHasher.observeEventType(.Value, withBlock: { hasherSnapshot in
                            print("1")
                            self.attendees = []
                            
                            if let hasherSnapshots = hasherSnapshot.children.allObjects as? [FDataSnapshot] {
                                print("2")
                                for hasherSnap in hasherSnapshots {
                                    print("3")
                                    if let attendeeDetailsDict = hasherSnap.value as? Dictionary<String, AnyObject> {
                                        print("this key is: \(hasherSnap.key)")
                                        let attendee = Hasher(hasherInitId: attendeeKeys[x], hasherInitDict: attendeeDetailsDict)
                                        print("attendee data: \(attendee)")
                                        self.attendees.append(attendee)
                                        print("attendees data first: \(self.attendees)")
                                    }
                                }
                            }
                        })
                    }
                }
            }
            self.trailAttendeeTableView.reloadData()
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
        return attendees.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print("current attendee data: \(attendees)")
        let thisAttendee = attendees[indexPath.row]
        if let cell = tableView.dequeueReusableCellWithIdentifier("trailAttendeeCell") as? AttendeeCell {
            cell.configureCell(thisAttendee)
            return cell
        } else {
            return AttendeeCell()
        }
    }
    
}



