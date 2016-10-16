//
//  AttendeeDetailsVC.swift
//  Hash Me
//
//  Created by Eric Klose on 4/11/16.
//  Copyright © 2016 Eric Klose. All rights reserved.
//

import UIKit
//import Firebase

class AttendeeDetailsVC: UIViewController {
    
    @IBOutlet weak var specificAttendeeRelevantHashName: UILabel!
    @IBOutlet weak var specificAttendeeHashNameField: UITextField!
    @IBOutlet weak var specificAttendeeNerdName: UITextField!
    @IBOutlet weak var specificAttendeeAttendingToggle: UISwitch!
    @IBOutlet weak var specificAttendeePaidToggle: UISwitch!
    @IBOutlet weak var specificAttendeeVisitingFrom: UILabel!
    @IBOutlet weak var specificAttendeeVirginSponsorIs: UILabel!
    @IBOutlet weak var specificAttendeeMinPayLbl: UILabel!
    @IBOutlet weak var specificAttendeeMaxPayLbl: UILabel!
    @IBOutlet weak var specificAttendeeCurrentPayLbl: UILabel!
    @IBOutlet weak var specificAttendeePaySlider: UISlider!
    @IBOutlet weak var specificAttendeeReducedPayReason: UITextField!
    
    var specificAttendee: Attendee!
    var trails: TrailData!
    
//    var isNewHasher: Bool = false
    var hashCash: Int = 0
    var trailAttendencePath = DataService.ds.REF_TRAILS
    var trailsAttendedPath = DataService.ds.REF_HASHERS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() 
        
        hashCash = specificAttendee.attendeeTrailHashCash
        
//        if isNewHasher == false {
//            specificAttendeeHashNameField.hidden = true
//            specificAttendeeRelevantHashName.hidden = false
            specificAttendeeRelevantHashName.text = specificAttendee.hasherPrimaryHashName
//        } else if isNewHasher == true {
//            specificAttendeeRelevantHashName.hidden = true
//            specificAttendeeHashNameField.hidden = false
//        }
        
        specificAttendeeNerdName.text = specificAttendee.hasherNerdName
        
        specificAttendeeVisitingFrom.text = specificAttendee.attendeeVisitingFrom
        specificAttendeeVirginSponsorIs.text = specificAttendee.attendeeVirginSponsor
        
        specificAttendeePaySlider.maximumValue = Float(((hashCash/20)+1)*20)
        specificAttendeePaySlider.setValue(Float(specificAttendee.attendeePaidAmount), animated: true)
        specificAttendeeMinPayLbl.text = "$0"
        specificAttendeeMaxPayLbl.text = "$\((Int(hashCash/20)+1)*20)"
        specificAttendeeCurrentPayLbl.text = "$\(specificAttendee.attendeePaidAmount)"
        specificAttendeeReducedPayReason.text = specificAttendee.attendeePaidNotes
        
        trailAttendencePath = DataService.ds.REF_TRAILS.child(specificAttendee.attendeeRelevantTrailId).child("trailAttendees").child(specificAttendee.hasherId)
        trailsAttendedPath = DataService.ds.REF_HASHERS.child(specificAttendee.hasherId).child("trailsAttended").child(specificAttendee.attendeeRelevantTrailId)
        
        
        specificAttendeeNerdName.text = specificAttendee.hasherNerdName
        
        if specificAttendee.attendeeAttending == true {
            specificAttendeeAttendingToggle.isOn = true
        } else {
            specificAttendeeAttendingToggle.isOn = false
        }
        
        if Int(specificAttendee.attendeePaidAmount) > 0 {
            specificAttendeePaidToggle.isOn = true
        } else {
            specificAttendeePaidToggle.isOn = false
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
    
    
    
    @IBAction func updateNerdName(_ sender: UITextField) {
        if specificAttendeeNerdName.text == "" || specificAttendeeNerdName.text == nil {
            DataService.ds.REF_HASHERS.child(specificAttendee.hasherId).child("hasherNerdName").removeValue()
        } else {
            DataService.ds.REF_HASHERS.child(specificAttendee.hasherId).updateChildValues(["hasherNerdName" : specificAttendeeNerdName.text!])
        }
    }
    
    @IBAction func toggleAttendingToggle(_ sender: UISwitch) {
        self.specificAttendee.attendeeSetIsPresent(specificAttendee.hasherId, trailId: specificAttendee.attendeeRelevantTrailId, attendeeIsPresent: sender.isOn)
        
        if specificAttendeeAttendingToggle.isOn == false {
            specificAttendeePaidToggle.setOn(false, animated: true)
        }
    }
    
    @IBAction func hasherPaidFullToggleToggled(_ sender: UISwitch) {
        if specificAttendeePaidToggle.isOn == true {
            self.specificAttendee.attendeeSetPaidAmt(specificAttendee.hasherId, trailId: specificAttendee.attendeeRelevantTrailId, attendeePaid: hashCash)
            specificAttendeeAttendingToggle.setOn(true, animated: true)
            toggleAttendingToggle(specificAttendeePaidToggle)
            specificAttendeeCurrentPayLbl.text = "$\(hashCash)"
            specificAttendeePaySlider.setValue(Float(hashCash), animated: true)
        } else if specificAttendeePaidToggle.isOn == false {
            self.specificAttendee.attendeeSetNotPaid(specificAttendee.hasherId, trailId: specificAttendee.attendeeRelevantTrailId)
            specificAttendeeReducedPayReason.text = ""
        }
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let selectedValue = Int(sender.value)
        if Int(selectedValue) > 0 {
            specificAttendeePaidToggle.setOn(true, animated: true)
        }
        specificAttendeeCurrentPayLbl.text = "$" + String(stringInterpolationSegment: selectedValue)
        self.specificAttendee.attendeeSetPaidAmt(specificAttendee.hasherId, trailId: specificAttendee.attendeeRelevantTrailId, attendeePaid: selectedValue)
    }
    
    @IBAction func hasherPaidDiscountReason(_ sender: UITextField) {
        specificAttendee.attendeeSetPaidReducedReason(specificAttendee.hasherId, trailId: specificAttendee.attendeeRelevantTrailId, attendeePaidReducedReason: specificAttendeeReducedPayReason.text!)
    }
    
    
    @IBAction func savespecificAttendeeDetails(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func getKennelFromKennelPickerVC(_ sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? KennelPickerTableVC {
            if sourceViewController.kennelChoiceId == nil {
                specificAttendeeVisitingFrom.text = ""
                trailAttendencePath.child("trailAttendeeVisitingFrom").removeValue()
                trailsAttendedPath.child("hasherVisitingFrom").removeValue()
            } else {
                specificAttendeeVisitingFrom.text = sourceViewController.kennelChoiceName
                trailAttendencePath.updateChildValues(["trailAttendeeVisitingFrom" : sourceViewController.kennelChoiceId])
                trailsAttendedPath.updateChildValues(["hasherVisitingFrom" : sourceViewController.kennelChoiceId])
            }
        }
    }
    
    @IBAction func getHasherFromHasherPickerVC(_ sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? HasherPickerTableVC {
            if sourceViewController.hasherChoiceId == nil {
                specificAttendeeVirginSponsorIs.text = ""
                trailAttendencePath.child("trailAttendeeVirginSponsorIs").removeValue()
                trailsAttendedPath.child("hasherVirginSponsor").removeValue()
                DataService.ds.REF_HASHERS.child(specificAttendee.hasherId).child("hasherVirginSponsor").removeValue()
            } else {
                specificAttendeeVirginSponsorIs.text = sourceViewController.hasherChoiceName
                trailAttendencePath.updateChildValues(["trailAttendeeVirginSponsorIs" : sourceViewController.hasherChoiceId])
                trailsAttendedPath.updateChildValues(["hasherVirginSponsor" : sourceViewController.hasherChoiceId])
                DataService.ds.REF_HASHERS.child(specificAttendee.hasherId).updateChildValues(["hasherVirginSponsor" : sourceViewController.hasherChoiceId])
            }
        }
    }
}

