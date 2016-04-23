//
//  AttendeeCell.swift
//  Hash Me
//
//  Created by Eric Klose on 4/11/16.
//  Copyright © 2016 Eric Klose. All rights reserved.
//

import UIKit
import Firebase

class AttendeeCell: UITableViewCell {
    
    
    @IBOutlet weak var hasherRelevantHashName: UITextField!
    @IBOutlet weak var hasherRelevantHashNameLbl: UILabel!
    @IBOutlet weak var hasherNerdName: UITextField!
    @IBOutlet weak var hasherNerdNameLbl: UILabel!
    @IBOutlet weak var hasherAttendingTrailToggle: UISwitch!
    @IBOutlet weak var hasherPaid: UISwitch!
    
    var attendee: Attendee!
//    var trailAttendencePath: Firebase!
//    var trailsAttendedPath: Firebase!
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
        
//        trailAttendencePath = DataService.ds.REF_TRAILS.childByAppendingPath(attendee.attendeeRelevantTrailId).childByAppendingPath("trailAttendees").childByAppendingPath(attendee.hasherId)
//        trailsAttendedPath = DataService.ds.REF_HASHERS.childByAppendingPath(attendee.hasherId).childByAppendingPath("trailsAttended").childByAppendingPath(attendee.attendeeRelevantTrailId)
        
        if attendee.hasherNerdName == "" || attendee.hasherNerdName == "Incognito" {
            self.hasherNerdNameLbl.hidden = true
            self.hasherNerdName.hidden = false
            self.hasherNerdName.text = ""
        } else {
            self.hasherNerdNameLbl.text = attendee.hasherNerdName
            self.hasherNerdNameLbl.hidden = false
            self.hasherNerdName.hidden = true
        }
        
        if attendee.attendeeAttending == true {
            self.hasherAttendingTrailToggle.on = true
        } else {
            self.hasherAttendingTrailToggle.on = false
        }
        
        if Int(attendee.attendeePaidAmount) > 0 {
            self.hasherPaid.on = true
            self.hasherAttendingTrailToggle.on = true
        } else {
            self.hasherPaid.on = false
        }
        
        if attendee.attendeeRelevantHashName == "" {
            self.hasherRelevantHashNameLbl.hidden = true
            self.hasherRelevantHashName.hidden = false
            self.hasherRelevantHashNameLbl.text = ""
        } else {
            self.hasherRelevantHashName.hidden = true
            self.hasherRelevantHashNameLbl.hidden = false
            self.hasherRelevantHashName.text = ""
            self.hasherRelevantHashNameLbl.text = attendee.attendeeRelevantHashName
        }
    }
    
    @IBAction func toggleAttendingToggle(sender: UISwitch) {
        self.attendee.attendeeSetIsPresent(attendee.hasherId, trailId: attendee.attendeeRelevantTrailId, attendeeIsPresent: sender.on)
        
        if hasherAttendingTrailToggle.on == false {
            hasherPaid.setOn(false, animated: true)
        }
    }
    
    @IBAction func hasherPaidToggleToggled(sender: UISwitch) {
        if hasherPaid.on == true {
            self.attendee.attendeeSetPaidAmt(attendee.hasherId, trailId: attendee.attendeeRelevantTrailId, attendeePaid: hashCash)
            hasherAttendingTrailToggle.setOn(true, animated: true)
            toggleAttendingToggle(hasherPaid)
        } else if hasherPaid.on == false {
            self.attendee.attendeeSetNotPaid(attendee.hasherId, trailId: attendee.attendeeRelevantTrailId)
        }
    }
    
    
    @IBAction func hasherNerdNameAdded(sender: UITextField) {
        if hasherNerdName.text != nil && hasherNerdName.text != "" {
            DataService.ds.REF_HASHERS.childByAppendingPath(attendee.hasherId).updateChildValues(["hasherNerdName" : hasherNerdName.text!])
        }
    }
    
    
}
