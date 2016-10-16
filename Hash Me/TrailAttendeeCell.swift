//
//  TrailAttendeeCell.swift (copied from AttendeeCell.swift)
//  Hash Me
//
//  Created by Eric Klose on 4/11/16.
//  Copyright © 2016 Eric Klose. All rights reserved.
//

import UIKit
import Firebase

class TrailAttendeeCell: UITableViewCell {
    
    
    @IBOutlet weak var hasherRelevantHashName: UITextField!
    @IBOutlet weak var hasherRelevantHashNameLbl: UILabel!
    @IBOutlet weak var hasherNerdName: UITextField!
    @IBOutlet weak var hasherNerdNameLbl: UILabel!
    @IBOutlet weak var hasherAttendingTrailToggle: UISwitch!
    @IBOutlet weak var hasherPaid: UISwitch!
    @IBOutlet weak var hasherPaidLbl: UILabel!
    
    var attendee: Attendee!
    var hashCash: Int = 0
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func configureCell(_ attendee: Attendee, hashCash: Int, userIsAdmin: Bool) {
        self.attendee = attendee
        self.hashCash = hashCash
        
        if attendee.hasherNerdName == "" || attendee.hasherNerdName == "Incognito" {
            self.hasherNerdNameLbl.isHidden = true
            self.hasherNerdName.isHidden = false
            self.hasherNerdName.text = ""
        } else {
            self.hasherNerdNameLbl.text = attendee.hasherNerdName
            self.hasherNerdNameLbl.isHidden = false
            self.hasherNerdName.isHidden = true
        }
        
        if attendee.attendeeAttending == true {
            self.hasherAttendingTrailToggle.isOn = true
        } else {
            self.hasherAttendingTrailToggle.isOn = false
        }
        
        if Int(attendee.attendeePaidAmount) > 0 {
            self.hasherPaid.isOn = true
            self.hasherAttendingTrailToggle.isOn = true
        } else {
            self.hasherPaid.isOn = false
        }
        
        if attendee.attendeeRelevantHashName == "" {
            self.hasherRelevantHashNameLbl.isHidden = true
            self.hasherRelevantHashName.isHidden = false
            self.hasherRelevantHashNameLbl.text = ""
        } else {
            self.hasherRelevantHashName.isHidden = true
            self.hasherRelevantHashNameLbl.isHidden = false
            self.hasherRelevantHashName.text = ""
            self.hasherRelevantHashNameLbl.text = attendee.attendeeRelevantHashName
        }
        
        if userIsAdmin == false {
            if attendee.hasherId == DataService.ds.REF_HASHER_USERID {
                self.hasherAttendingTrailToggle.isUserInteractionEnabled = true
            } else {
                self.hasherAttendingTrailToggle.isUserInteractionEnabled = false
            }
            self.hasherPaid.isHidden = true
            self.hasherRelevantHashName.isHidden = true
            self.hasherRelevantHashNameLbl.isHidden = false
            self.hasherNerdName.isHidden = true
            self.hasherNerdNameLbl.isHidden = false
            self.hasherPaidLbl.isHidden = true
        }
    }
    
    @IBAction func toggleAttendingToggle(_ sender: UISwitch) {
        self.attendee.attendeeSetIsPresent(attendee.hasherId, trailId: attendee.attendeeRelevantTrailId, attendeeIsPresent: sender.isOn)
        
        if hasherAttendingTrailToggle.isOn == false {
            hasherPaid.setOn(false, animated: true)
        }
    }
    
    @IBAction func hasherPaidToggleToggled(_ sender: UISwitch) {
        if hasherPaid.isOn == true {
            self.attendee.attendeeSetPaidAmt(attendee.hasherId, trailId: attendee.attendeeRelevantTrailId, attendeePaid: hashCash)
            hasherAttendingTrailToggle.setOn(true, animated: true)
            toggleAttendingToggle(hasherPaid)
        } else if hasherPaid.isOn == false {
            self.attendee.attendeeSetNotPaid(attendee.hasherId, trailId: attendee.attendeeRelevantTrailId)
        }
    }
    
    
    @IBAction func hasherNerdNameAdded(_ sender: UITextField) {
        if hasherNerdName.text != nil && hasherNerdName.text != "" {
            DataService.ds.REF_HASHERS.child(attendee.hasherId).updateChildValues(["hasherNerdName" : hasherNerdName.text!])
        }
    }
    
    
}
