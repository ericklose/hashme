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
    @IBOutlet weak var trailHaresTableView: UITableView!
    
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
    
    var newHasher: Dictionary<String, AnyObject> = [:]
    var trailInfo: Dictionary<String, AnyObject> = ["trailAttendeePresent" : true]
    var newHasherTrails: Dictionary<String, AnyObject> = ["hasherAttendedTrail": true]
    
    var trails: TrailData!
    var attendees = [Attendee]()
    var filteredHashers = [Attendee]()
    var potentialAttendees = [Attendee]()
    var trailRoster = [Attendee]()
    var trailHareNamesDict: Dictionary<String, String> = [:]
    var hashCash: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trailAttendeeTableView.delegate = self
        trailAttendeeTableView.dataSource = self
        trailHaresTableView.delegate = self
        trailHaresTableView.dataSource = self
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
                
                self.trailHareNamesDict = [:]
                self.attendees = []
                self.potentialAttendees = []
                self.trailRoster = []
                
                for hasherSnap in hasherSnapshots {
                    
                    if let attendeeDataDict = hasherSnap.value as? Dictionary<String, AnyObject> {
                        
                            if self.trails.trailHares[hasherSnap.key] != nil {
                                let hareHashName = attendeeDataDict["hasherPrimaryHashName"] as! String
                                self.trailHareNamesDict[hasherSnap.key] = hareHashName
                            }
                        
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
            self.trailHaresTableView.reloadData()
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
    
    func updateTrailDetails() {
        hashCash = trails.trailHashCash
        specificTrailDate.text = trails.trailDate
        specificTrailKennel.text = trails.trailKennelName
        specificTrailStartLocation.text = trails.trailStartLocation
        //specificTrailHares.text = trails.trailHares
        specificTrailDescription.text = trails.trailDescription
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(tableView == self.trailHaresTableView) {
            return 23
        } else {
            return 60
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == self.trailHaresTableView) {
            return trails.trailHares.count
        } else {
            if inSearchMode {
                return filteredHashers.count
            } else {
                return trailRoster.count
            }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView == trailHaresTableView {
            let hares = [String](trails.trailHares.keys)
            let hare = hares[indexPath.row]
            if let hareCell = tableView.dequeueReusableCellWithIdentifier("hareCell") as? HareCell {
                hareCell.configureCell(hare, hares: trails.trailHares, hareNameDict: trailHareNamesDict)
                return hareCell
            } else {
                return HareCell()
            }
        } else {
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
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(tableView == self.trailHaresTableView) {
            
        } else {
            let specificAttendee: Attendee!
            
            if inSearchMode {
                specificAttendee = filteredHashers[indexPath.row]
            } else {
                specificAttendee = trailRoster[indexPath.row]
            }
            performSegueWithIdentifier("attendeeDetails", sender: specificAttendee)
        }
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
            newHasherAttendingToggle.setOn(true, animated: true)
            newHasherCurrentPayLbl.text = "$\(hashCash)"
            newHasherPaySlider.setValue(Float(hashCash), animated: true)
        }
    }
    
    @IBAction func getKennelFromKennelPickerVC(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? KennelPickerTableVC {
            if sourceViewController.kennelChoiceId == nil {
                newHasherVisitorFrom.text = ""
                newHasher["hasherPrimaryKennel"] = trails.trailKennelId
                let newHasherKennelsAndNames: Dictionary<String, AnyObject> = [trails.trailKennelId: "primary"]
                newHasher["hasherKennelsAndName"] = newHasherKennelsAndNames
            } else {
                newHasherVisitorFrom.text = sourceViewController.kennelChoiceName
                newHasher["hasherPrimaryKennel"] = newHasherVisitorFrom.text
                let newHasherKennelsAndNames: Dictionary<String, AnyObject> = [sourceViewController.kennelChoiceId: "primary"]
                newHasher["hasherKennelsAndName"] = newHasherKennelsAndNames
                newHasherTrails["hasherVisitingFrom"] = sourceViewController.kennelChoiceId
                trailInfo["trailAttendeeVisitingFrom"] = sourceViewController.kennelChoiceId
                newHasherTrails["hasherVisitedKennel"] = trails.trailKennelId
            }
        }
    }
    
    @IBAction func getHasherFromHasherPickerVC(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? HasherPickerTableVC {
            if sourceViewController.hasherChoiceId == nil {
                newHasherVirginSponsorIs.text = ""
                newHasher["hasherVirginSponsor"] = nil
                newHasherTrails["hasherVirginSponsor"] = nil
                trailInfo["trailAttendeeVirginSponsorIs"] = nil
            } else {
                newHasherVirginSponsorIs.text = sourceViewController.hasherChoiceName
                newHasher["hasherVirginSponsor"] = sourceViewController.hasherChoiceId
                newHasherTrails["hasherVirginSponsor"] = sourceViewController.hasherChoiceId
                trailInfo["trailAttendeeVirginSponsorIs"] = sourceViewController.hasherChoiceId
            }
        }
    }
    
    @IBAction func addNewHasher(sender: UIButton) {
        
        if newHasherHashName.text == nil || newHasherHashName.text == "" {
            
            newHasherHashName.placeholder = "Hash Name Required"
            newHasherHashName.backgroundColor = UIColor.redColor()
            
        } else {
            newHasher["hasherPrimaryHashName"] = newHasherHashName.text!
            
            if newHasherNerdName.text != nil && newHasherNerdName.text != "" {
                newHasher["hasherNerdName"] = newHasherNerdName.text
            }
            
            if newHasherAttendingToggle.on == true {
                if newHasherPaidToggle.on == true {
                    newHasherTrails["hasherPaidTrailAmt"] = Int(newHasherPaySlider.value)
                    trailInfo["trailAttendeePaidAmt"] = Int(newHasherPaySlider.value)
                }
                if newHasherReducedPayReason.text != nil && newHasherReducedPayReason.text != "" {
                    newHasherTrails["hasherPaidReducedReason"] = newHasherReducedPayReason.text
                    trailInfo["trailAttendeePaidReducedReason"] = newHasherReducedPayReason.text
                }
            }
            
            let firebasePost = DataService.ds.REF_HASHERS.childByAutoId()
            firebasePost.setValue(newHasher)
            let newHasherId = firebasePost.key
            
            let firebasePost2 = DataService.ds.REF_HASHERS.childByAppendingPath(newHasherId).childByAppendingPath("trailsAttended").childByAppendingPath(trails.trailKey)
            firebasePost2.setValue(newHasherTrails)
            
            let firebaseTrailPost = DataService.ds.REF_TRAILS.childByAppendingPath(trails.trailKey).childByAppendingPath("trailAttendees").childByAppendingPath(newHasherId)
            firebaseTrailPost.setValue(trailInfo)
            
            let firebaseKennelTrailPost = DataService.ds.REF_KENNELS.childByAppendingPath(trails.trailKennelId).childByAppendingPath("kennelTrails").childByAppendingPath(trails.trailKey).childByAppendingPath("trailAttendees").childByAppendingPath(newHasherId)
            firebaseTrailPost.setValue(trailInfo)
            
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
        }
    }
    
}



