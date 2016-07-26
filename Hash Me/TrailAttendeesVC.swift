//
//  TrailAttendeesVC.swift
//  Hash Me
//
//  Created by Holly Klose on 5/13/16.
//  Copyright © 2016 Eric Klose. All rights reserved.
//

import UIKit
import Firebase

class TrailAttendeesVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var trailAttendeeTableView: UITableView!
    
    @IBOutlet weak var attendeeSearchBar: UISearchBar!
    var inSearchMode = false
    
    var trails: TrailData!
    var attendees = [Attendee]()
    var filteredHashers = [Attendee]()
//    var potentialAttendees = [Attendee]()
    var trailRoster = [Attendee]()
    var fakeAttendee: Attendee!
    var userIsAdmin = false
    var userIsHare = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.hideKeyboardWhenTappedAround()
        trailAttendeeTableView.delegate = self
        trailAttendeeTableView.dataSource = self
        attendeeSearchBar.delegate = self
        attendeeSearchBar.returnKeyType = UIReturnKeyType.Done
    }
    
    override func viewDidAppear(animated: Bool) {
        fakeAttendee = Attendee(attendeeInitId: "fake", attendeeInitDict: [:], attendeeInitTrailId: "fake", attendeeInitKennelId: "fake", attendeeAttendingInit: false, attendeeInitTrailHashCash: 0)
        
        fakeAttendee.getAttendeeInfo(trails) { () -> () in
            self.trailRoster = self.fakeAttendee.unpaidAttendees + self.fakeAttendee.attendees + self.fakeAttendee.potentialAttendees

            for user in self.trailRoster {
                if case user.hasherId = DataService.ds.REF_HASHER_USERID {
                    self.userIsAdmin = user.attendeeIsAdmin
                    print("admin status: ", user.attendeeRelevantHashName, self.userIsAdmin)
                    self.userIsHare = user.attendeeIsHare
                    print("hare status: ", user.attendeeRelevantHashName, self.userIsHare)
                }
            }
            
            self.trailAttendeeTableView.reloadData()
            
        }
    }

//      I THINK THIS IS ALL BEING DONE IN ATTENDEE DATA
//    func addPotential(hasherKey: String, attendeeDataDict: Dictionary <String, AnyObject>, attendeeAttending: Bool) {
//        let potentialAttendee = Attendee(attendeeInitId: hasherKey, attendeeInitDict: attendeeDataDict, attendeeInitTrailId: self.trails.trailKey, attendeeInitKennelId: self.trails.trailKennelId, attendeeAttendingInit: attendeeAttending, attendeeInitTrailHashCash: self.trails.trailHashCash)
//        if hasherKey == DataService.ds.REF_HASHER_USERID {
//            self.attendees.insert(potentialAttendee, atIndex: 0)
//        } else if attendeeAttending == true {
//            self.attendees.append(potentialAttendee)
//        } else {
//            self.potentialAttendees.append(potentialAttendee)
//        }
//    }
    
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
            cell.configureCell(hasherResult, hashCash: self.trails.trailHashCash, userIsAdmin: self.userIsAdmin)
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
        if userIsAdmin == true {
        performSegueWithIdentifier("trailAttendeeDetails", sender: specificAttendee)
        } else {
            showErrorAlert("Only Admins Can Edit Attendees", msg: "You need to be an admin of this kennel to be able to record and change attendance")
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "trailAttendeeDetails" {
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
    
    
    
}



