//
//  ManageTrailVC.swift
//  Hash Me
//
//  Created by Eric Klose on 3/13/16.
//  Copyright © 2016 Eric Klose. All rights reserved.
//

import UIKit
//import Firebase

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
    var trailInfo: Dictionary<String, AnyObject> = ["trailAttendeePresent" : true as AnyObject]
    var newHasherTrails: Dictionary<String, AnyObject> = ["hasherAttendedTrail": true as AnyObject]
    
    var trails: TrailData!
    var attendees = [Attendee]()
    var filteredHashers = [Attendee]()
    var potentialAttendees = [Attendee]()
    var trailRoster = [Attendee]()
    var trailHareNamesDict: Dictionary<String, String> = [:]
    var hashCash: Int!
    var fakeAttendee: Attendee!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        This keyboard thing makes cells unclickable ... need to fix somehow
//        self.hideKeyboardWhenTappedAround()
        trailAttendeeTableView.delegate = self
        trailAttendeeTableView.dataSource = self
        trailHaresTableView.delegate = self
        trailHaresTableView.dataSource = self
        attendeeSearchBar.delegate = self
        attendeeSearchBar.returnKeyType = UIReturnKeyType.done
        
        updateTrailDetails()
        
        newHasherPaidToggle.isOn = false
        newHasherAttendingToggle.isOn = false
        newHasherPaySlider.maximumValue = Float(((hashCash/20)+1)*20)
        newHasherPaySlider.setValue(Float(hashCash), animated: true)
        newHasherMinPayLbl.text = "$0"
        newHasherMaxPayLbl.text = "$\((Int(hashCash/20)+1)*20)"
        newHasherCurrentPayLbl.text = "$\(hashCash)"
        
        newHasher["hasherPrimaryKennel"] = trails.trailKennelId as AnyObject?
        let newHasherKennelsAndNames: Dictionary<String, AnyObject> = [trails.trailKennelId: "primary" as AnyObject]
        newHasher["hasherKennelsAndName"] = newHasherKennelsAndNames as AnyObject?

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        fakeAttendee = Attendee(attendeeInitId: "fake", attendeeInitDict: [:], attendeeInitTrailId: "fake", attendeeInitKennelId: "fake", attendeeAttendingInit: false, attendeeInitTrailHashCash: 0)
        
        fakeAttendee.getAttendeeInfo(trails) { () -> () in
            self.trailRoster = self.fakeAttendee.unpaidAttendees + self.fakeAttendee.attendees + self.fakeAttendee.potentialAttendees
            self.trailAttendeeTableView.reloadData()
            self.trailHaresTableView.reloadData()
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if(tableView == self.trailHaresTableView) {
            return 23
        } else {
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == trailHaresTableView {
            let hares = [String](trails.trailHares.keys)
            let hare = hares[(indexPath as NSIndexPath).row]
            if let hareCell = tableView.dequeueReusableCell(withIdentifier: "hareCell") as? HareCell {
                hareCell.configureCell(hare, hares: trails.trailHares, hareNameDict: trailHareNamesDict)
                return hareCell
            } else {
                return HareCell()
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "trailAttendeeCell") as? AttendeeCell {
                let hasherResult: Attendee!
                if inSearchMode {
                    hasherResult = filteredHashers[(indexPath as NSIndexPath).row]
                } else {
                    hasherResult = trailRoster[(indexPath as NSIndexPath).row]
                }
                cell.configureCell(hasherResult, hashCash: self.trails.trailHashCash)
                return cell
            } else {
                return AttendeeCell()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView == self.trailHaresTableView) {
            
        } else {
            let specificAttendee: Attendee!
            
            if inSearchMode {
                specificAttendee = filteredHashers[(indexPath as NSIndexPath).row]
            } else {
                specificAttendee = trailRoster[(indexPath as NSIndexPath).row]
            }
            performSegue(withIdentifier: "attendeeDetails", sender: specificAttendee)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "attendeeDetails" {
            if let attendeeDetailsVC = segue.destination as? AttendeeDetailsVC {
                if let attendeeInCell = sender as? Attendee {
                    attendeeDetailsVC.specificAttendee = attendeeInCell
                }
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            topContentBlock.isHidden = false
            topContentBlock.frame.size.height = 440
            view.endEditing(true)
            self.trailAttendeeTableView.reloadData()
        } else {
            inSearchMode = true
            topContentBlock.isHidden = true
            topContentBlock.frame.size.height = 0
            let lower = searchBar.text!.lowercased()
            filteredHashers = trailRoster.filter({$0.attendeeRelevantHashName.lowercased().range(of: lower) != nil || $0.hasherNerdName.lowercased().range(of: lower) != nil})
            self.trailAttendeeTableView.reloadData()
        }
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let selectedValue = Int(sender.value)
        newHasherCurrentPayLbl.text = "$" + String(stringInterpolationSegment: selectedValue)
    }
    
    @IBAction func newHasherPaidToggled(_ sender: UISwitch) {
        if newHasherPaidToggle.isOn == true {
            newHasherAttendingToggle.setOn(true, animated: true)
            newHasherCurrentPayLbl.text = "$\(hashCash)"
            newHasherPaySlider.setValue(Float(hashCash), animated: true)
        }
    }
    
    @IBAction func getKennelFromKennelPickerVC(_ sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? KennelPickerTableVC {
            if sourceViewController.kennelChoiceId == nil {
                newHasherVisitorFrom.text = ""
                newHasher["hasherPrimaryKennel"] = trails.trailKennelId as AnyObject?
                let newHasherKennelsAndNames: Dictionary<String, AnyObject> = [trails.trailKennelId: "primary" as AnyObject]
                newHasher["hasherKennelsAndName"] = newHasherKennelsAndNames as AnyObject?
            } else {
                newHasherVisitorFrom.text = sourceViewController.kennelChoiceName
                newHasher["hasherPrimaryKennel"] = sourceViewController.kennelChoiceId as AnyObject?
                let newHasherKennelsAndNames: Dictionary<String, AnyObject> = [sourceViewController.kennelChoiceId: "primary" as AnyObject]
                newHasher["hasherKennelsAndName"] = newHasherKennelsAndNames as AnyObject?
                newHasherTrails["hasherVisitingFrom"] = sourceViewController.kennelChoiceId as AnyObject?
                trailInfo["trailAttendeeVisitingFrom"] = sourceViewController.kennelChoiceId as AnyObject?
                newHasherTrails["hasherVisitedKennel"] = trails.trailKennelId as AnyObject?
            }
        }
    }
    
    @IBAction func getHasherFromHasherPickerVC(_ sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? HasherPickerTableVC {
            if sourceViewController.hasherChoiceId == nil {
                newHasherVirginSponsorIs.text = ""
                newHasher["hasherVirginSponsor"] = nil
                newHasherTrails["hasherVirginSponsor"] = nil
                trailInfo["trailAttendeeVirginSponsorIs"] = nil
            } else {
                newHasherVirginSponsorIs.text = sourceViewController.hasherChoiceName
                newHasher["hasherVirginSponsor"] = sourceViewController.hasherChoiceId as AnyObject?
                newHasherTrails["hasherVirginSponsor"] = sourceViewController.hasherChoiceId as AnyObject?
                trailInfo["trailAttendeeVirginSponsorIs"] = sourceViewController.hasherChoiceId as AnyObject?
            }
        }
    }
    
    @IBAction func addNewHasher(_ sender: UIButton) {
        
        if newHasherHashName.text == nil || newHasherHashName.text == "" {
            
            newHasherHashName.placeholder = "Hash Name Required"
            newHasherHashName.backgroundColor = UIColor.red
            
        } else {
            newHasher["hasherPrimaryHashName"] = newHasherHashName.text! as AnyObject?
            
            if newHasherNerdName.text != nil && newHasherNerdName.text != "" {
                newHasher["hasherNerdName"] = newHasherNerdName.text as AnyObject?
            }
            
            if newHasherAttendingToggle.isOn == true {
                if newHasherPaidToggle.isOn == true {
                    newHasherTrails["hasherPaidTrailAmt"] = Int(newHasherPaySlider.value) as AnyObject?
                    trailInfo["trailAttendeePaidAmt"] = Int(newHasherPaySlider.value) as AnyObject?
                }
                if newHasherReducedPayReason.text != nil && newHasherReducedPayReason.text != "" {
                    newHasherTrails["hasherPaidReducedReason"] = newHasherReducedPayReason.text as AnyObject?
                    trailInfo["trailAttendeePaidReducedReason"] = newHasherReducedPayReason.text as AnyObject?
                }
            }
            
            let firebasePost = DataService.ds.REF_HASHERS.childByAutoId()
            firebasePost.setValue(newHasher)
            let newHasherId = firebasePost.key
//            let initializedNewHasher = Hasher(hasherInitId: newHasherId, hasherInitDict: newHasher)
            
            let firebasePost2 = DataService.ds.REF_HASHERS.child(newHasherId).child("trailsAttended").child(trails.trailKey)
            firebasePost2.setValue(newHasherTrails)
            
            let firebaseTrailPost = DataService.ds.REF_TRAILS.child(trails.trailKey).child("trailAttendees").child(newHasherId)
            firebaseTrailPost.setValue(trailInfo)
            
//            let firebaseKennelTrailPost = DataService.ds.REF_KENNELS.child(trails.trailKennelId).child("kennelTrails").child(trails.trailKey).child("trailAttendees").child(newHasherId)
//            firebaseKennelTrailPost.setValue(kennelInfo)
            
            if newHasherVisitorFrom == nil || newHasherVisitorFrom.text == "" {
                DataService.ds.REF_KENNELS.child(trails.trailKennelId).child("kennelMembers").updateChildValues([newHasherId : true])
            } else {
                let homeKennel = newHasherTrails["hasherVisitingFrom"] as! String
                DataService.ds.REF_KENNELS.child(homeKennel).child("kennelMembers").updateChildValues([newHasherId : true])
            }

            newHasherHashName.text = ""
            newHasherHashName.placeholder = "Hash Name"
            newHasherHashName.backgroundColor = nil
            newHasherNerdName.text = ""
            newHasherAttendingToggle.isOn = false
            newHasherPaidToggle.isOn = false
            newHasherVisitorFrom.text = ""
            newHasherVirginSponsorIs.text = ""
            newHasherCurrentPayLbl.text = "$\(hashCash)"
            newHasherPaySlider.setValue(Float(hashCash), animated: true)
            newHasherReducedPayReason.text = ""
            newHasher["hasherPrimaryKennel"] = trails.trailKennelId as AnyObject?
            let newHasherKennelsAndNames: Dictionary<String, AnyObject> = [trails.trailKennelId: "primary" as AnyObject]
            newHasher["hasherKennelsAndName"] = newHasherKennelsAndNames as AnyObject?
        }
    }
    
}



