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
    var potentialAttendees = [Hasher]()
    var trailRoster = [Hasher]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trailAttendeeTableView.delegate = self
        trailAttendeeTableView.dataSource = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        updateTrailDetails()
        
        DataService.ds.REF_HASHERS.observeEventType(.Value, withBlock: { hasherSnapshot in
            
            if let hasherSnapshots = hasherSnapshot.children.allObjects as? [FDataSnapshot] {
                
                self.attendees = []
                self.potentialAttendees = []
                self.trailRoster = []
                
                for hasherSnap in hasherSnapshots {
                    
                    if let hasherDataDict = hasherSnap.value as? Dictionary<String, AnyObject> {
                    
                    if let isMarkedAsPresent = hasherDataDict["trailsAttended"] as? Dictionary<String, AnyObject> {
                        let trailList = [String](isMarkedAsPresent.keys)
                        if trailList.contains(self.trails.trailKey) {
                            let hasherKey = hasherSnap.key
                            let attendee = Hasher(hasherInitId: hasherKey, hasherInitDict: hasherDataDict)
                            self.attendees.append(attendee)
                        } else {
                            let hasherKey = hasherSnap.key
                            let potentialAttendee = Hasher(hasherInitId: hasherKey, hasherInitDict: hasherDataDict)
                            self.potentialAttendees.append(potentialAttendee)
                        }
                    } else {
                        let hasherKey = hasherSnap.key
                        let potentialAttendee = Hasher(hasherInitId: hasherKey, hasherInitDict: hasherDataDict)
                        self.potentialAttendees.append(potentialAttendee)
                    }
                }
            }
            }
            self.trailRoster = self.attendees + self.potentialAttendees
            self.trailAttendeeTableView.reloadData()
        })
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
        return trailRoster.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let thisAttendee = trailRoster[indexPath.row]
        if let cell = tableView.dequeueReusableCellWithIdentifier("trailAttendeeCell") as? AttendeeCell {
            cell.configureCell(thisAttendee)
            return cell
        } else {
            return AttendeeCell()
        }
    }
    
}



