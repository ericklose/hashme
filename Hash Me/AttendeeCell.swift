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

    
    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    func configureCell(attendee: Attendee) {
        self.attendee = attendee
        
        trailAttendencePath = DataService.ds.REF_TRAILS.childByAppendingPath(attendee.attendeeRelevantTrailId).childByAppendingPath("trailAttendees").childByAppendingPath(attendee.hasherId)
        trailsAttendedPath = DataService.ds.REF_HASHERS.childByAppendingPath(attendee.hasherId).childByAppendingPath("trailsAttended").childByAppendingPath(attendee.attendeeRelevantTrailId)
        
        self.hasherNerdName.text = attendee.hasherNerdName
        self.hasherHashNames.text = attendee.attendeeRelevantHashName

        if attendee.attendeeAttending == true {
            self.hasherPresent.on = true
        } else {
            self.hasherPresent.on = false
        }
        
        self.hasherIsVirgin.on = false
        self.hasherIsVisitor.on = false
        self.hasherPaidFull.on = false
        self.hasherVirginSponsorIs.text = ""
        self.hasherVisitorFrom.text = ""
        self.hasherPaySlider.value = 10
        self.hasherMinPayLbl.text = "$0"
        self.hasherMaxPayLbl.text = "$20"
        self.hasherCurrentPayLbl.text = "$10"
        self.hasherPaidReducedReason.text = "various reasons"
        
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
            trailAttendencePath.updateChildValues(["trailAttendeePaidAmt" : 15])
            trailsAttendedPath.updateChildValues(["hasherPaidTrailAmt" : 15])
            hasherCurrentPayLbl.text = "$15"
            hasherPaySlider.value = 15
        } else if self.hasherPaidFull.on == false {
            trailAttendencePath.updateChildValues(["trailAttendeePaidAmt" : 0])
            trailsAttendedPath.updateChildValues(["hasherPaidTrailAmt" : 0])
        }
    }
    
    @IBAction func sliderValueChanged(sender: UISlider) {
        self.hasherPaidFull.on = false
        
        let selectedValue = Int(sender.value)
        hasherCurrentPayLbl.text = "$" + String(stringInterpolationSegment: selectedValue)
        
        self.trailAttendencePath.updateChildValues(["trailAttendeePaidAmt" : selectedValue])
        self.trailsAttendedPath.updateChildValues(["hasherPaidTrailAmt" : selectedValue])
    }

    
    @IBAction func hasherPaidDiscountReason(sender: AnyObject) {
        
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
    
    @IBAction func hasherVirginSponsorIs(sender: AnyObject) {
        
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
    
    @IBAction func hasherIsVisitingFrom(sender: AnyObject) {
        
    }
    
    
}
