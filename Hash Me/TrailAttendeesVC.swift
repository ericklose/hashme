//
// (Duplicated and changed to TrailAttendeesVC) ManageTrailVC.swift
//  Hash Me
//
//  Created by Eric Klose on 3/13/16.
//  Copyright © 2016 Eric Klose. All rights reserved.
//

import UIKit
import FirebaseDatabase

class TrailAttendeesVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var trailAttendeeTableView: UITableView!
    
    @IBOutlet weak var attendeeSearchBar: UISearchBar!
    var inSearchMode = false
    
    var trails: TrailData!
    var attendees = [Attendee]()
    var filteredHashers = [Attendee]()
    var potentialAttendees = [Attendee]()
    var trailRoster = [Attendee]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.hideKeyboardWhenTappedAround()
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
        DataService.ds.REF_HASHERS.observeEventType(.Value, withBlock: { hasherSnapshot in
            
            if let hasherSnapshots = hasherSnapshot.children.allObjects as? [FIRDataSnapshot] {
                
                self.attendees = []
                self.potentialAttendees = []
                self.trailRoster = []
                
                for hasherSnap in hasherSnapshots {
                    
                    if let attendeeDataDict = hasherSnap.value as? Dictionary<String, AnyObject> {
                        
                            if let atThisTrail = attendeeDataDict["trailsAttended"] as? Dictionary<String, AnyObject> {
                                let thisTrail = self.trails.trailKey
                                if let thisTrailDict = atThisTrail[thisTrail] as? Dictionary<String, AnyObject> {
                                    if (thisTrailDict["hasherAttendedTrail"] as? Bool) == true {
                                        let hasherKey = hasherSnap.key
                                        self.addPotential(hasherKey, attendeeDataDict: attendeeDataDict, attendeeAttending: true)
                                    }
                                }
                                //IF SOME TRAILS ATTENDED, BUT NOT THIS ONE
                                else {
                                    self.addPotential(hasherSnap.key, attendeeDataDict: attendeeDataDict, attendeeAttending: false)
                                }
                            }
                            //IF ZERO TRAILS ATTENDED IN HASHER DATA
                            else {
                              self.addPotential(hasherSnap.key, attendeeDataDict: attendeeDataDict, attendeeAttending: false)
                        }
                    }
                }
            }
            
            self.trailRoster = self.attendees + self.potentialAttendees
            self.trailAttendeeTableView.reloadData()
        })
    }
    
    func addPotential(hasherKey: String, attendeeDataDict: Dictionary <String, AnyObject>, attendeeAttending: Bool) {
        let potentialAttendee = Attendee(attendeeInitId: hasherKey, attendeeInitDict: attendeeDataDict, attendeeInitTrailId: self.trails.trailKey, attendeeInitKennelId: self.trails.trailKennelId, attendeeAttendingInit: attendeeAttending, attendeeInitTrailHashCash: self.trails.trailHashCash)
        if hasherKey == DataService.ds.REF_HASHER_USERID {
            self.attendees.insert(potentialAttendee, atIndex: 0)
        } else if attendeeAttending == true {
            self.attendees.append(potentialAttendee)
        } else {
            self.potentialAttendees.append(potentialAttendee)
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
            return 63
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
   
            if inSearchMode {
                return filteredHashers.count
            } else {
                return trailRoster.count
            }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            if let cell = tableView.dequeueReusableCellWithIdentifier("trailAttendeeCell") as? TrailAttendeeCell {
                let hasherResult: Attendee!
                if inSearchMode {
                    hasherResult = filteredHashers[indexPath.row]
                } else {
                    hasherResult = trailRoster[indexPath.row]
                }
                cell.configureCell(hasherResult, hashCash: self.trails.trailHashCash)
                return cell
            } else {
                return TrailAttendeeCell()
            }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            let specificAttendee: Attendee!
            
            if inSearchMode {
                specificAttendee = filteredHashers[indexPath.row]
            } else {
                specificAttendee = trailRoster[indexPath.row]
            }
            performSegueWithIdentifier("attendeeDetails", sender: specificAttendee)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "attendeeDetails" {
            if let attendeeDetailsVC = segue.destinationViewController as? AttendeeDetailsVC {
                if let attendeeInCell = sender as? Attendee {
                    attendeeDetailsVC.specificAttendee = attendeeInCell
                }
            }
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
    
    
    //NEED TO ADD ABILITY FOR BOTH INDIVIDUAL HASHER AND ADMIN TO RVSP GOING OR NOT
    //NEED TO ADD ABILITY FOR ONLY ADMIN TO MARK PAID (AND HIDE PAID SWITCH IF NOT ADMIN
    //NEED TO LET CLICKING ON ROW GO TO ADD/EDIT HASHER VC, JUST LIKE ADD HASHER DOES, ALSO MOVE ADD HASHER BUTTON TO TOP BAR
    
//    @IBAction func sliderValueChanged(sender: UISlider) {
//        let selectedValue = Int(sender.value)
//        newHasherCurrentPayLbl.text = "$" + String(stringInterpolationSegment: selectedValue)
//    }
    
//    @IBAction func newHasherPaidToggled(sender: UISwitch) {
//        if newHasherPaidToggle.on == true {
//            newHasherAttendingToggle.setOn(true, animated: true)
//            newHasherCurrentPayLbl.text = "$\(hashCash)"
//            newHasherPaySlider.setValue(Float(hashCash), animated: true)
//        }
//    }
    
}



