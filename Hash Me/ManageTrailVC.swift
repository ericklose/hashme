//
//  ManageTrailVC.swift
//  Hash Me
//
//  Created by Eric Klose on 3/13/16.
//  Copyright © 2016 Eric Klose. All rights reserved.
//

import UIKit
import Firebase

class ManageTrailVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var trailAttendeeTableView: UITableView!
    
    @IBOutlet weak var attendeeSearchBar: UISearchBar!
    var inSearchMode = false
    
    
    @IBOutlet weak var specificTrailDate: UILabel!
    @IBOutlet weak var specificTrailKennel: UILabel!
    @IBOutlet weak var specificTrailStartLocation: UILabel!
    @IBOutlet weak var specificTrailHares: UILabel!
    @IBOutlet weak var specificTrailDescription: UILabel!
    
    
    var trails: TrailData!
    var attendees = [Attendee]()
    var filteredHashers = [Attendee]()
    var potentialAttendees = [Attendee]()
    var trailRoster = [Attendee]()
    var hashCash: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trailAttendeeTableView.delegate = self
        trailAttendeeTableView.dataSource = self
        attendeeSearchBar.delegate = self
        attendeeSearchBar.returnKeyType = UIReturnKeyType.Done
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
                    
                    if let attendeeDataDict = hasherSnap.value as? Dictionary<String, AnyObject> {
                        
                        if let atThisTrail = attendeeDataDict["trailsAttended"] as? Dictionary<String, AnyObject> {
                            let thisTrail = self.trails.trailKey
                            
                            if let thisTrailDict = atThisTrail[thisTrail] as? Dictionary<String, AnyObject> {
                                
                                if (thisTrailDict["hasherAttendedTrail"] as? String) != nil {
                                    let hasherKey = hasherSnap.key
                                    let attendee = Attendee(attendeeInitId: hasherKey, attendeeInitDict: attendeeDataDict, attendeeInitTrailId: self.trails.trailKey, attendeeInitKennelId: self.trails.trailKennel, attendeeAttendingInit: true)
                                    self.attendees.append(attendee)
                                } else {
                                    self.addPotential(hasherSnap.key, attendeeDataDict: attendeeDataDict)
                                }
                            } else {
                                self.addPotential(hasherSnap.key, attendeeDataDict: attendeeDataDict)
                            }
                        } else {
                            self.addPotential(hasherSnap.key, attendeeDataDict: attendeeDataDict)
                        }
                    }
                }
            }
            self.trailRoster = self.attendees + self.potentialAttendees
            let fakeNames: [String: AnyObject] = ["": "primary"]
            let fakeDict: [String: AnyObject] = ["hasherNerdName": "", "hasherHashNames": fakeNames]
            let placeholder = DataService.ds.REF_HASHERS.childByAutoId()
            let blankCell = Attendee(attendeeInitId: placeholder.key, attendeeInitDict: fakeDict, attendeeInitTrailId: self.trails.trailKey, attendeeInitKennelId: self.trails.trailKennel, attendeeAttendingInit: false)
            self.trailRoster.insert(blankCell, atIndex: 0)
            self.trailAttendeeTableView.reloadData()
        })
    }
    
    func addPotential(hasherKey: String, attendeeDataDict: Dictionary <String, AnyObject>) {
        let potentialAttendee = Attendee(attendeeInitId: hasherKey, attendeeInitDict: attendeeDataDict, attendeeInitTrailId: self.trails.trailKey, attendeeInitKennelId: self.trails.trailKennel, attendeeAttendingInit: false)
        self.potentialAttendees.append(potentialAttendee)
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
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if inSearchMode {
            return filteredHashers.count
        } else {
            return trailRoster.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let thisAttendee = trailRoster[indexPath.row]
        if let cell = tableView.dequeueReusableCellWithIdentifier("trailAttendeeCell") as? AttendeeCell {
            
            let hasherResult: Attendee!
            
            if inSearchMode {
                hasherResult = filteredHashers[indexPath.row]
            } else {
                hasherResult = trailRoster[indexPath.row]
            }
            
            cell.configureCell(hasherResult, hashCash: self.trails.trailHashCash)
            return cell
        } else {
            return AttendeeCell()
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            view.endEditing(true)
            self.trailAttendeeTableView.reloadData()
        } else {
            inSearchMode = true
            let lower = searchBar.text!.lowercaseString
            filteredHashers = trailRoster.filter({$0.attendeeRelevantHashName.lowercaseString.rangeOfString(lower) != nil || $0.hasherNerdName.lowercaseString.rangeOfString(lower) != nil})
            self.trailAttendeeTableView.reloadData()
        }
    }
    
    
}



