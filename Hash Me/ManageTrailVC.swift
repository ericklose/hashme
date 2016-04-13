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
    
    //Outlets for the trail info
    @IBOutlet weak var specificTrailDate: UILabel!
    @IBOutlet weak var specificTrailKennel: UILabel!
    @IBOutlet weak var specificTrailStartLocation: UILabel!
    @IBOutlet weak var specificTrailHares: UILabel!
    @IBOutlet weak var specificTrailDescription: UILabel!
    
    //Outlets for the Add New Hasher section
    @IBOutlet weak var newHasherHashName: UITextField!
    @IBOutlet weak var newHasherNerdName: UITextField!
    @IBOutlet weak var newHasherAttendingToggle: UISwitch!
    @IBOutlet weak var newHasherPaidToggle: UISwitch!
    
    //Outlets for the questionable section of Add New Hasher
    @IBOutlet weak var newHasherVisitorFrom: UITextField!
    @IBOutlet weak var newHasherVirginSponsorIs: UITextField!
    @IBOutlet weak var newHasherPaySlider: UISlider!
    @IBOutlet weak var newHasherMinPayLbl: UILabel!
    @IBOutlet weak var newHasherMaxPayLbl: UILabel!
    @IBOutlet weak var newHasherCurrentPayLbl: UILabel!
    @IBOutlet weak var newHasherReducedPayReason: UITextField!
    
    @IBOutlet weak var topContentBlock: UIView!
    
    
    var trails: TrailData!
    var attendees = [Attendee]()
    var filteredHashers = [Attendee]()
    var potentialAttendees = [Attendee]()
    var trailRoster = [Attendee]()
    var hashCash: Int!
    var isHidden: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trailAttendeeTableView.delegate = self
        trailAttendeeTableView.dataSource = self
        attendeeSearchBar.delegate = self
        attendeeSearchBar.returnKeyType = UIReturnKeyType.Done
        
        updateTrailDetails()
        
        newHasherPaidToggle.on = false
        newHasherAttendingToggle.on = false
        newHasherPaySlider.maximumValue = Float(((hashCash/20)+1)*20)
        newHasherPaySlider.setValue(Float(hashCash), animated: true)
        newHasherMinPayLbl.text = "$0"
        newHasherMaxPayLbl.text = "$\((Int(hashCash/20)+1)*20)"
        newHasherCurrentPayLbl.text = "$\(hashCash)"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        
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
            self.trailAttendeeTableView.reloadData()
        })
    }
    
    func addPotential(hasherKey: String, attendeeDataDict: Dictionary <String, AnyObject>) {
        let potentialAttendee = Attendee(attendeeInitId: hasherKey, attendeeInitDict: attendeeDataDict, attendeeInitTrailId: self.trails.trailKey, attendeeInitKennelId: self.trails.trailKennel, attendeeAttendingInit: false)
        self.potentialAttendees.append(potentialAttendee)
    }
    
    func updateTrailDetails() {
        hashCash = trails.trailHashCash
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let specificAttendee: Attendee!
        
        if inSearchMode {
            specificAttendee = filteredHashers[indexPath.row]
        } else {
            specificAttendee = trailRoster[indexPath.row]
        }
        print("hi: \(specificAttendee.hasherPrimaryHashName)")
        performSegueWithIdentifier("attendeeDetails", sender: specificAttendee)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "attendeeDetails" {
            if let attendeeDetailsVC = segue.destinationViewController as? AttendeeDetailsVC {
                if let attendeeInCell = sender as? Attendee {
                    attendeeDetailsVC.specificAttendee = attendeeInCell
                    print("inside prep segue: \(attendeeDetailsVC.specificAttendee.hasherNerdName)")
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
            topContentBlock.hidden = false
            topContentBlock.frame.size.height = 440
            view.endEditing(true)
            self.trailAttendeeTableView.reloadData()
        } else {
            inSearchMode = true
            topContentBlock.hidden = true
            topContentBlock.frame.size.height = 0
            let lower = searchBar.text!.lowercaseString
            filteredHashers = trailRoster.filter({$0.attendeeRelevantHashName.lowercaseString.rangeOfString(lower) != nil || $0.hasherNerdName.lowercaseString.rangeOfString(lower) != nil})
            self.trailAttendeeTableView.reloadData()
        }
    }
    
    @IBAction func sliderValueChanged(sender: UISlider) {
        let selectedValue = Int(sender.value)
        
        newHasherCurrentPayLbl.text = "$" + String(stringInterpolationSegment: selectedValue)
        
    }
    
    @IBAction func newHasherPaidToggled(sender: UISwitch) {
        if newHasherPaidToggle.on == true {
            newHasherAttendingToggle.on = true
            newHasherCurrentPayLbl.text = "$\(hashCash)"
            newHasherPaySlider.setValue(Float(hashCash), animated: true)
        }
    }
    
    @IBAction func addNewHasher(sender: UIButton) {
        
        if newHasherHashName.text == nil || newHasherHashName.text == "" {
            
            newHasherHashName.placeholder = "Hash Name Required"
            newHasherHashName.backgroundColor = UIColor.redColor()
            
        } else {
            
            var newHasher: Dictionary<String, AnyObject> = ["hasherPrimaryHashName": newHasherHashName.text!]
            
            if newHasherNerdName.text != nil && newHasherNerdName.text != "" {
                newHasher["hasherNerdName"] = newHasherNerdName.text
            }
            
            if newHasherVisitorFrom.text == nil || newHasherVisitorFrom.text == "" {
                newHasher["hasherPrimaryKennel"] = trails.trailKennel
                let newHasherKennelsAndNames: Dictionary<String, AnyObject> = [trails.trailKennel: "primary"]
                newHasher["hasherKennelsAndName"] = newHasherKennelsAndNames
            } else {
                newHasher["hasherPrimaryKennel"] = newHasherVisitorFrom.text
                let newHasherKennelsAndNames: Dictionary<String, AnyObject> = [newHasherVisitorFrom.text!: "primary"]
                newHasher["hasherKennelsAndName"] = newHasherKennelsAndNames
            }
            
            if newHasherVirginSponsorIs.text != nil && newHasherVirginSponsorIs.text != "" {
                newHasher["hasherVirginSponser"] = newHasherVirginSponsorIs.text
            }
            
            if newHasherAttendingToggle.on == true {
                var newHasherTrails: Dictionary<String, AnyObject> = ["hasherAttendedTrail": true]
                if newHasherPaidToggle.on == true {
                    newHasherTrails["hasherPaidTrailAmt"] = Int(newHasherPaySlider.value)
                }
                if newHasherReducedPayReason.text != nil && newHasherReducedPayReason.text != "" {
                    newHasherTrails["hasherPaidReducedReason"] = newHasherReducedPayReason.text
                }
                newHasher["trailsAttended"] = newHasherTrails
            }
            
            let firebasePost = DataService.ds.REF_HASHERS.childByAutoId()
            firebasePost.setValue(newHasher)
            
            newHasherHashName.text = ""
            newHasherHashName.placeholder = "Hash Name"
            newHasherHashName.backgroundColor = nil
            newHasherNerdName.text = ""
            newHasherAttendingToggle.on = false
            newHasherPaidToggle.on = false
            newHasherVisitorFrom.text = ""
            newHasherVirginSponsorIs.text = ""
            newHasherCurrentPayLbl.text = "$\(hashCash)"
            newHasherPaySlider.setValue(Float(hashCash), animated: true)
            newHasherReducedPayReason.text = ""
            //self.navigationController?.popViewControllerAnimated(true)
            
        }
    }
    
}



