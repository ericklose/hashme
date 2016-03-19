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
            
            if let generalDict = snapshot.value as? Dictionary<String, AnyObject> {
                let attendeeDict = generalDict["trailAttendees"] as? Dictionary<String, AnyObject>
                print("ATTENDEE DICT:\(attendeeDict)")
                let attendeeKeys = [String](attendeeDict!.keys)
                print("Just the keys are: \(attendeeKeys)")
                
                if attendeeDict != nil {
                    //for var x = 0; x < attendeeDict!.count; x++ {
                    //     let attendingHasher = Firebase(url: "\(DataService.ds.REF_HASHERS)").childByAppendingPath(attendeeKeys[x])
                    
                    DataService.ds.REF_HASHERS.observeEventType(.Value, withBlock: { hasherSnapshot in
                        
                        self.attendees = []

                        if let hasherSnapshots = hasherSnapshot.children.allObjects as? [FDataSnapshot] {

                            for hasherSnap in hasherSnapshots {
                          
                                print("testing: \(hasherSnap.value["trailsAttended"])")
                                
                                if let attendeeDetailsDict = hasherSnapshot.value as? Dictionary<String, AnyObject> /*where hasherSnap.value["trailsAttended"]   */{
                                    let attendee = Hasher(hasherInitId: hasherSnapshot.key, hasherInitDict: attendeeDetailsDict)
                                    self.attendees.append(attendee)
                                }
                            }
                            
                        }
                        //self.trailAttendeeTableView.reloadData()
                    })
                }
                //}
            }
            //self.trailAttendeeTableView.reloadData()
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
        print("theAttendee: \(thisAttendee)")
        if let cell = tableView.dequeueReusableCellWithIdentifier("trailAttendeeCell") as? AttendeeCell {
            cell.configureCell(thisAttendee)
            return cell
        } else {
            return AttendeeCell()
        }
    }
    
}



