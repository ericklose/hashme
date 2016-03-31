//
//  AttendeeCell.swift
//  Hash Me
//
//  Created by Holly Klose on 3/14/16.
//  Copyright © 2016 Eric Klose. All rights reserved.
//

import UIKit
import Firebase

class AttendeeCell: UITableViewCell {
    
    @IBOutlet weak var hasherNerdName: UITextField!
    @IBOutlet weak var hasherHashNames: UITextField!
    @IBOutlet weak var hasherHashNameLbl: UILabel!
    @IBOutlet weak var hasherNerdNameLbl: UILabel!
    @IBOutlet weak var hasherPresent: UISwitch!
    @IBOutlet weak var hasherIsVisitor: UISwitch!
    @IBOutlet weak var hasherIsVirgin: UISwitch!
    @IBOutlet weak var hasherPaidFull: UISwitch!
    @IBOutlet weak var hasherVisitorFrom: UITextField!
    @IBOutlet weak var hasherVirginSponsorIs: UITextField!
    @IBOutlet weak var hasherPaySlider: UISlider!
    @IBOutlet weak var hasherPaidReducedReason: UITextField!
    @IBOutlet weak var hasherAttendingTrailToggle: UISwitch!
    @IBOutlet weak var hasherMinPayLbl: UILabel!
    @IBOutlet weak var hasherMaxPayLbl: UILabel!
    @IBOutlet weak var hasherCurrentPayLbl: UILabel!
    
    var attendee: Attendee!
    var trailAttendencePath: Firebase!
    var trailsAttendedPath: Firebase!
    var hashCash = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    func configureCell(attendee: Attendee, hashCash: Int) {
        self.attendee = attendee
        self.hashCash = hashCash
        
        trailAttendencePath = DataService.ds.REF_TRAILS.childByAppendingPath(attendee.attendeeRelevantTrailId).childByAppendingPath("trailAttendees").childByAppendingPath(attendee.hasherId)
        trailsAttendedPath = DataService.ds.REF_HASHERS.childByAppendingPath(attendee.hasherId).childByAppendingPath("trailsAttended").childByAppendingPath(attendee.attendeeRelevantTrailId)
        
        if attendee.hasherNerdName == "" {
            self.hasherNerdNameLbl.hidden = true
            self.hasherNerdName.hidden = false
            self.hasherNerdName.text = ""
        } else {
            self.hasherNerdName.hidden = true
            self.hasherNerdNameLbl.hidden = false
            self.hasherNerdName.text = ""
            self.hasherNerdNameLbl.text = attendee.hasherNerdName
        }
        print("1")
        if attendee.attendeeRelevantHashName == "" {
            print("a")
            self.hasherHashNameLbl.hidden = true
            self.hasherHashNames.hidden = false
            self.hasherHashNames.text = ""
        } else {
            print("b")
            self.hasherHashNames.hidden = true
            self.hasherHashNameLbl.hidden = false
            self.hasherHashNames.text = ""
            self.hasherHashNameLbl.text = attendee.attendeeRelevantHashName
        }
        
        if attendee.attendeeAttending == true {
            self.hasherPresent.on = true
        } else {
            self.hasherPresent.on = false
        }
        self.hasherIsVirgin.on = attendee.attendeeVirginTrail
        self.hasherIsVisitor.on = attendee.attendeeVisitingTrail
        self.hasherPaidFull.on = false
        self.hasherVirginSponsorIs.text = attendee.attendeeVirginSponsor
        self.hasherVisitorFrom.text = attendee.attendeeVisitingFrom
        self.hasherPaySlider.value = Float(attendee.attendeePaidAmount)
        self.hasherMinPayLbl.text = "$0"
        self.hasherMaxPayLbl.text = "$\((Int(hashCash/20)+1)*20)"
        self.hasherCurrentPayLbl.text = "$\(attendee.attendeePaidAmount)"
        self.hasherPaidReducedReason.text = attendee.attendeePaidNotes
    }
    
    @IBAction func toggleAttendingToggle(sender: UISwitch) {
        
        if hasherAttendingTrailToggle.on == true {
            trailAttendencePath.updateChildValues(["trailAttendeePresent" : "true"])
            trailsAttendedPath.updateChildValues(["hasherAttendedTrail" : "true"])
        } else if hasherAttendingTrailToggle.on  == false {
            trailAttendencePath.removeValue()
            trailsAttendedPath.removeValue()
        }
    }
    
    @IBAction func hasherPaidFullToggleToggled(sender: UISwitch) {
        if self.hasherPaidFull.on == true {
            trailAttendencePath.updateChildValues(["trailAttendeePaidAmt" : "\(hashCash)"])
            trailsAttendedPath.updateChildValues(["hasherPaidTrailAmt" : "\(hashCash)"])
            hasherCurrentPayLbl.text = "$\(hashCash)"
            hasherPaySlider.value = Float(hashCash)
        } else if self.hasherPaidFull.on == false {
            trailAttendencePath.updateChildValues(["trailAttendeePaidAmt" : 0])
            trailsAttendedPath.updateChildValues(["hasherPaidTrailAmt" : 0])
        }
    }
    
    @IBAction func sliderValueChanged(sender: UISlider) {
        let selectedValue = Int(sender.value)
        
        if selectedValue - hashCash < 1 {
            self.hasherPaidFull.on = true
        } else {
            self.hasherPaidFull.on = false
        }
        
        hasherCurrentPayLbl.text = "$" + String(stringInterpolationSegment: selectedValue)
        
        self.trailAttendencePath.updateChildValues(["trailAttendeePaidAmt" : selectedValue])
        self.trailsAttendedPath.updateChildValues(["hasherPaidTrailAmt" : selectedValue])
    }
    
    
    @IBAction func hasherPaidDiscountReason(sender: UITextField) {
        if self.hasherPaidReducedReason.text == "" {
            trailAttendencePath.childByAppendingPath("trailAttendeePaidReducedReason").removeValue()
            trailsAttendedPath.childByAppendingPath("hasherPaidReducedReason").removeValue()
        } else {
            trailAttendencePath.updateChildValues(["trailAttendeePaidReducedReason" : self.hasherPaidReducedReason.text!])
            trailsAttendedPath.updateChildValues(["hasherPaidReducedReason" : self.hasherPaidReducedReason.text!])
        }
    }
    
    @IBAction func hasherIsVirginToggled(sender: UISwitch) {
        if self.hasherIsVirgin.on == true {
            trailAttendencePath.updateChildValues(["trailAttendeeIsVirgin" : true])
            trailsAttendedPath.updateChildValues(["hasherVirginTrail" : true])
        } else if self.hasherIsVirgin.on == false {
            trailAttendencePath.childByAppendingPath("trailAttendeeIsVirgin").removeValue()
            trailsAttendedPath.childByAppendingPath("hasherVirginTrail").removeValue()
        }
    }
    
    @IBAction func hasherVirginSponsorIs(sender: UITextField) {
        if self.hasherVirginSponsorIs.text == "" {
            trailAttendencePath.childByAppendingPath("trailAttendeeVirginSponsor").removeValue()
            trailsAttendedPath.childByAppendingPath("hasherVirginSponsor").removeValue()
        } else {
            trailAttendencePath.updateChildValues(["trailAttendeeVirginSponsor" : self.hasherVirginSponsorIs.text!])
            trailsAttendedPath.updateChildValues(["hasherVirginSponsor" : self.hasherVirginSponsorIs.text!])
        }
    }
    
    @IBAction func hasherIsVisitorToggled(sender: UISwitch) {
        if self.hasherIsVisitor.on == true {
            trailAttendencePath.updateChildValues(["trailAttendeeIsVisitor" : true])
            trailsAttendedPath.updateChildValues(["hasherWasVisiting" : true])
        } else if self.hasherIsVisitor.on == false {
            trailAttendencePath.childByAppendingPath("trailAttendeeIsVisitor").removeValue()
            trailsAttendedPath.childByAppendingPath("hasherWasVisiting").removeValue()
        }
    }
    
    @IBAction func hasherIsVisitingFrom(sender: UITextField) {
        if self.hasherVisitorFrom.text == "" {
            trailAttendencePath.childByAppendingPath("trailAttendeeVisitingFrom").removeValue()
            trailsAttendedPath.childByAppendingPath("hasherVisitingFrom").removeValue()
        } else {
            trailAttendencePath.updateChildValues(["trailAttendeeVisitingFrom" : self.hasherVisitorFrom.text!])
            trailsAttendedPath.updateChildValues(["hasherVisitingFrom" : self.hasherVisitorFrom.text!])
        }
    }
    
    
}
