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
    
    @IBOutlet weak var specificAttendeeRelevantHashName: UILabel!
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
    
    var hashCash: Int = 0
    var trailAttendencePath = DataService.ds.REF_TRAILS
    var trailsAttendedPath = DataService.ds.REF_HASHERS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() 
        
        hashCash = specificAttendee.attendeeTrailHashCash
        
        specificAttendeeRelevantHashName.text = specificAttendee.hasherPrimaryHashName
        specificAttendeeNerdName.text = specificAttendee.hasherNerdName
        
        specificAttendeeVisitingFrom.text = specificAttendee.attendeeVisitingFrom
        specificAttendeeVirginSponsorIs.text = specificAttendee.attendeeVirginSponsor
        
        
        specificAttendeePaySlider.maximumValue = Float(((hashCash/20)+1)*20)
        specificAttendeePaySlider.setValue(Float(specificAttendee.attendeePaidAmount), animated: true)
        specificAttendeeMinPayLbl.text = "$0"
        specificAttendeeMaxPayLbl.text = "$\((Int(hashCash/20)+1)*20)"
        specificAttendeeCurrentPayLbl.text = "$\(specificAttendee.attendeePaidAmount)"
        specificAttendeeReducedPayReason.text = specificAttendee.attendeePaidNotes
        
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
    
    @IBAction func updateNerdName(sender: UITextField) {
        if specificAttendeeNerdName.text == "" || specificAttendeeNerdName.text == nil {
            DataService.ds.REF_HASHERS.childByAppendingPath(specificAttendee.hasherId).childByAppendingPath("hasherNerdName").removeValue()
        } else {
            DataService.ds.REF_HASHERS.childByAppendingPath(specificAttendee.hasherId).updateChildValues(["hasherNerdName" : specificAttendeeNerdName.text!])
        }
    }
    
    @IBAction func toggleAttendingToggle(sender: UISwitch) {
        self.specificAttendee.attendeeSetIsPresent(specificAttendee.hasherId, trailId: specificAttendee.attendeeRelevantTrailId, attendeeIsPresent: sender.on)
        
        if specificAttendeeAttendingToggle.on == false {
            specificAttendeePaidToggle.setOn(false, animated: true)
        }
    }
    
    @IBAction func hasherPaidFullToggleToggled(sender: UISwitch) {
        if specificAttendeePaidToggle.on == true {
            self.specificAttendee.attendeeSetPaidAmt(specificAttendee.hasherId, trailId: specificAttendee.attendeeRelevantTrailId, attendeePaid: hashCash)
            specificAttendeeAttendingToggle.setOn(true, animated: true)
            toggleAttendingToggle(specificAttendeePaidToggle)
            specificAttendeeCurrentPayLbl.text = "$\(hashCash)"
            specificAttendeePaySlider.setValue(Float(hashCash), animated: true)
        } else if specificAttendeePaidToggle.on == false {
            self.specificAttendee.attendeeSetNotPaid(specificAttendee.hasherId, trailId: specificAttendee.attendeeRelevantTrailId)
            specificAttendeeReducedPayReason.text = ""
        }
    }
    
    @IBAction func sliderValueChanged(sender: UISlider) {
        let selectedValue = Int(sender.value)
        if Int(selectedValue) > 0 {
            specificAttendeePaidToggle.setOn(true, animated: true)
        }
        specificAttendeeCurrentPayLbl.text = "$" + String(stringInterpolationSegment: selectedValue)
        self.specificAttendee.attendeeSetPaidAmt(specificAttendee.hasherId, trailId: specificAttendee.attendeeRelevantTrailId, attendeePaid: selectedValue)
    }
    
    @IBAction func hasherPaidDiscountReason(sender: UITextField) {
        specificAttendee.attendeeSetPaidReducedReason(specificAttendee.hasherId, trailId: specificAttendee.attendeeRelevantTrailId, attendeePaidReducedReason: specificAttendeeReducedPayReason.text!)
    }
    
    
    @IBAction func savespecificAttendeeDetails(sender: UIButton) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func getKennelFromKennelPickerVC(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? KennelPickerTableVC {
            if sourceViewController.kennelChoiceId == nil {
                specificAttendeeVisitingFrom.text = ""
                trailAttendencePath.childByAppendingPath("trailAttendeeVisitingFrom").removeValue()
                trailsAttendedPath.childByAppendingPath("hasherVisitingFrom").removeValue()
            } else {
                specificAttendeeVisitingFrom.text = sourceViewController.kennelChoiceName
                trailAttendencePath.updateChildValues(["trailAttendeeVisitingFrom" : sourceViewController.kennelChoiceId])
                trailsAttendedPath.updateChildValues(["hasherVisitingFrom" : sourceViewController.kennelChoiceId])
            }
        }
    }
    
    @IBAction func getHasherFromHasherPickerVC(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? HasherPickerTableVC {
            if sourceViewController.hasherChoiceId == nil {
                specificAttendeeVirginSponsorIs.text = ""
                trailAttendencePath.childByAppendingPath("trailAttendeeVirginSponsorIs").removeValue()
                trailsAttendedPath.childByAppendingPath("hasherVirginSponsor").removeValue()
                DataService.ds.REF_HASHERS.childByAppendingPath(specificAttendee.hasherId).childByAppendingPath("hasherVirginSponsor").removeValue()
            } else {
                specificAttendeeVirginSponsorIs.text = sourceViewController.hasherChoiceName
                trailAttendencePath.updateChildValues(["trailAttendeeVirginSponsorIs" : sourceViewController.hasherChoiceId])
                trailsAttendedPath.updateChildValues(["hasherVirginSponsor" : sourceViewController.hasherChoiceId])
                DataService.ds.REF_HASHERS.childByAppendingPath(specificAttendee.hasherId).updateChildValues(["hasherVirginSponsor" : sourceViewController.hasherChoiceId])
            }
        }
    }
}

