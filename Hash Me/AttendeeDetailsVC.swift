//
//  AttendeeDetailsVC.swift
//  Hash Me
//
//  Created by Eric Klose on 4/11/16.
//  Copyright © 2016 Eric Klose. All rights reserved.
//

import UIKit
import Firebase

class AttendeeDetailsVC: UIViewController {
    
    @IBOutlet weak var specificAttendeeRelevantHashName: UITextField!
    @IBOutlet weak var specificAttendeeNerdName: UITextField!
    @IBOutlet weak var specificAttendeeAttendingToggle: UISwitch!
    @IBOutlet weak var specificAttendeePaidToggle: UISwitch!
    @IBOutlet weak var specificAttendeeVisitingFrom: UITextField!
    @IBOutlet weak var specificAttendeeVirginSponsorIs: UITextField!
    @IBOutlet weak var specificAttendeeMinPayLbl: UILabel!
    @IBOutlet weak var specificAttendeeMaxPayLbl: UILabel!
    @IBOutlet weak var specificAttendeeCurrentPayLbl: UILabel!
    @IBOutlet weak var specificAttendeePaySlider: UISlider!
    @IBOutlet weak var specificAttendeeReducedPayReason: UITextField!
    
    var specificAttendee: Attendee!
    var hashCash: Int = 99 //specificAttendee.hashCash
    var trailAttendencePath = DataService.ds.REF_TRAILS
    var trailsAttendedPath = DataService.ds.REF_HASHERS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        specificAttendeeRelevantHashName.text = specificAttendee.hasherPrimaryHashName
        specificAttendeeNerdName.text = specificAttendee.hasherNerdName
        
        specificAttendeeVirginSponsorIs.text = specificAttendee.attendeeVirginSponsor
        specificAttendeeVisitingFrom.text = specificAttendee.attendeeVisitingFrom
        
        
        specificAttendeePaySlider.maximumValue = Float(((hashCash/20)+1)*20)
        specificAttendeePaySlider.setValue(Float(specificAttendee.attendeePaidAmount), animated: true)
        specificAttendeeMinPayLbl.text = "$0"
        specificAttendeeMaxPayLbl.text = "$\((Int(hashCash/20)+1)*20)"
        specificAttendeeCurrentPayLbl.text = "$\(specificAttendee.attendeePaidAmount)"
        specificAttendeeReducedPayReason.text = specificAttendee.attendeePaidNotes
        
        
        
        //hashCash = hashCash
        
        trailAttendencePath = DataService.ds.REF_TRAILS.childByAppendingPath(specificAttendee.attendeeRelevantTrailId).childByAppendingPath("trailAttendees").childByAppendingPath(specificAttendee.hasherId)
        trailsAttendedPath = DataService.ds.REF_HASHERS.childByAppendingPath(specificAttendee.hasherId).childByAppendingPath("trailsAttended").childByAppendingPath(specificAttendee.attendeeRelevantTrailId)
        
        
        specificAttendeeNerdName.text = specificAttendee.hasherNerdName
        
        if specificAttendee.attendeeAttending == true {
            specificAttendeeAttendingToggle.on = true
        } else {
            specificAttendeeAttendingToggle.on = false
        }
        
        if Int(specificAttendee.attendeePaidAmount) > 0 {
            specificAttendeePaidToggle.on = true
        } else {
            specificAttendeePaidToggle.on = false
        }
        
        specificAttendeeVirginSponsorIs.text = specificAttendee.attendeeVirginSponsor
        specificAttendeeVisitingFrom.text = specificAttendee.attendeeVisitingFrom
        
        specificAttendeePaySlider.maximumValue = Float(((hashCash/20)+1)*20)
        specificAttendeePaySlider.setValue(Float(specificAttendee.attendeePaidAmount), animated: true)
        specificAttendeeMinPayLbl.text = "$0"
        specificAttendeeMaxPayLbl.text = "$\((Int(hashCash/20)+1)*20)"
        specificAttendeeCurrentPayLbl.text = "$\(specificAttendee.attendeePaidAmount)"
        specificAttendeeReducedPayReason.text = specificAttendee.attendeePaidNotes
        
        
        specificAttendeeRelevantHashName.text = specificAttendee.attendeeRelevantHashName
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func toggleAttendingToggle(sender: UISwitch) {
        if specificAttendeeAttendingToggle.on == true {
            trailAttendencePath.updateChildValues(["trailAttendeePresent" : "true"])
            trailsAttendedPath.updateChildValues(["hasherAttendedTrail" : "true"])
        } else if specificAttendeeAttendingToggle.on  == false {
            trailAttendencePath.removeValue()
            trailsAttendedPath.removeValue()
        }
    }
    
    @IBAction func hasherPaidFullToggleToggled(sender: UISwitch) {
        if specificAttendeePaidToggle.on == true {
            trailAttendencePath.updateChildValues(["trailAttendeePaidAmt" : hashCash])
            trailsAttendedPath.updateChildValues(["hasherPaidTrailAmt" : hashCash])
            specificAttendeeCurrentPayLbl.text = "$\(hashCash)"
            specificAttendeePaySlider.setValue(Float(hashCash), animated: true)
        } else if specificAttendeePaidToggle.on == false {
            trailAttendencePath.updateChildValues(["trailAttendeePaidAmt" : 0])
            trailsAttendedPath.updateChildValues(["hasherPaidTrailAmt" : 0])
        }
    }
    
    @IBAction func sliderValueChanged(sender: UISlider) {
        let selectedValue = Int(sender.value)
        
        if Int(selectedValue) > Int(hashCash) {
            specificAttendeePaidToggle.setOn(true, animated: true)
        }
        
        specificAttendeeCurrentPayLbl.text = "$" + String(stringInterpolationSegment: selectedValue)
        
        trailAttendencePath.updateChildValues(["trailAttendeePaidAmt" : selectedValue])
        trailsAttendedPath.updateChildValues(["hasherPaidTrailAmt" : selectedValue])
    }
    
    
    @IBAction func hasherPaidDiscountReason(sender: UITextField) {
        if specificAttendeeReducedPayReason.text == "" {
            trailAttendencePath.childByAppendingPath("trailAttendeePaidReducedReason").removeValue()
            trailsAttendedPath.childByAppendingPath("hasherPaidReducedReason").removeValue()
        } else {
            trailAttendencePath.updateChildValues(["trailAttendeePaidReducedReason" : specificAttendeeReducedPayReason.text!])
            trailsAttendedPath.updateChildValues(["hasherPaidReducedReason" : specificAttendeeReducedPayReason.text!])
        }
    }
    
    
    @IBAction func hasherVirginSponsorIs(sender: UITextField) {
        if specificAttendeeVirginSponsorIs.text == "" {
            trailAttendencePath.childByAppendingPath("trailAttendeeVirginSponsor").removeValue()
            trailsAttendedPath.childByAppendingPath("hasherVirginSponsor").removeValue()
        } else {
            trailAttendencePath.updateChildValues(["trailAttendeeVirginSponsor" : specificAttendeeVirginSponsorIs.text!])
            trailsAttendedPath.updateChildValues(["hasherVirginSponsor" : specificAttendeeVirginSponsorIs.text!])
        }
    }
    
    
    @IBAction func hasherIsVisitingFrom(sender: UITextField) {
        if specificAttendeeVisitingFrom.text == "" {
            trailAttendencePath.childByAppendingPath("trailAttendeeVisitingFrom").removeValue()
            trailsAttendedPath.childByAppendingPath("hasherVisitingFrom").removeValue()
        } else {
            trailAttendencePath.updateChildValues(["trailAttendeeVisitingFrom" : specificAttendeeVisitingFrom.text!])
            trailsAttendedPath.updateChildValues(["hasherVisitingFrom" : specificAttendeeVisitingFrom.text!])
        }
    }
    
    
    
    @IBAction func savespecificAttendeeDetails(sender: UIButton) {
        navigationController?.popViewControllerAnimated(true)
    }
}

