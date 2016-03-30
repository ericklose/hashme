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
        self.hasherMinPayLbl.text = "0"
        self.hasherMaxPayLbl.text = "20"
        self.hasherCurrentPayLbl.text = "10"
        self.hasherPaidReducedReason.text = "various reasons"
        
    }
    
    @IBAction func toggleAttendingToggle(sender: UISwitch) {
        
        let trailAttendencePath1 = DataService.ds.REF_TRAILS.childByAppendingPath(attendee.attendeeRelevantTrailId).childByAppendingPath("trailAttendees")
        let trailAttendencePath2 = DataService.ds.REF_HASHERS.childByAppendingPath(attendee.hasherId).childByAppendingPath("trailsAttended")
    
        if hasherAttendingTrailToggle.on == true {
            trailAttendencePath1.updateChildValues([attendee.hasherId : "true"])
            trailAttendencePath2.updateChildValues([attendee.attendeeRelevantTrailId : "true"])
        } else if hasherAttendingTrailToggle.on  == false {
            trailAttendencePath1.childByAppendingPath(attendee.hasherId).removeValue()
            trailAttendencePath2.childByAppendingPath(attendee.attendeeRelevantTrailId).removeValue()
        }
    }
    
    @IBAction func sliderValueChanged(sender: UISlider) {
        let selectedValue = Int(sender.value)
        hasherCurrentPayLbl.text = "$" + String(stringInterpolationSegment: selectedValue)
    }
    
    
}
