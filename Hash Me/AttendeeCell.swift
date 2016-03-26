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
    @IBOutlet weak var hasherPaidReduced: UISlider!
    @IBOutlet weak var hasherPaidReducedReason: UITextField!
    @IBOutlet weak var hasherAttendingTrailToggle: UISwitch!
    
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
        self.hasherPaidReduced.value = 10
        self.hasherPaidReducedReason.text = "various reasons"
        
    }
    
    @IBAction func toggleAttendingToggle(sender: UISwitch) {
        if hasherAttendingTrailToggle.on == true {
            let trailAttendencePath1 = DataService.ds.REF_TRAILS.childByAppendingPath(attendee.attendeeRelevantTrailId).childByAppendingPath("trailAttendees")
            trailAttendencePath1.updateChildValues([attendee.hasherId : "true"])
            let trailAttendencePath2 = DataService.ds.REF_HASHERS.childByAppendingPath(attendee.hasherId).childByAppendingPath("trailsAttended")
            trailAttendencePath2.updateChildValues([attendee.attendeeRelevantTrailId : "true"])
        } else if hasherAttendingTrailToggle.on  == false {
            let trailAttendencePath1 = DataService.ds.REF_TRAILS.childByAppendingPath(attendee.attendeeRelevantTrailId).childByAppendingPath("trailAttendees").childByAppendingPath(attendee.hasherId)
            trailAttendencePath1.removeValue()
            let trailAttendencePath2 = DataService.ds.REF_HASHERS.childByAppendingPath(attendee.hasherId).childByAppendingPath("trailsAttended").childByAppendingPath(attendee.attendeeRelevantTrailId)
            trailAttendencePath2.removeValue()
        }
    }
}
