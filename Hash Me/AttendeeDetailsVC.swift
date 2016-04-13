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
    @IBOutlet weak var specificAttendeeRelevantHashNameLbl: UILabel!
    @IBOutlet weak var specificAttendeeNerdName: UITextField!
    @IBOutlet weak var specificAttendeeNerdNameLbl: UILabel!
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
    //var hashCash: Int = specificAttendee.hashCash
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        specificAttendeeRelevantHashName.text = specificAttendee.hasherPrimaryHashName
        specificAttendeeNerdName.text = specificAttendee.hasherNerdName
        
        specificAttendeeVirginSponsorIs.text = specificAttendee.attendeeVirginSponsor
        specificAttendeeVisitingFrom.text = specificAttendee.attendeeVisitingFrom
        
        
//        specificAttendeePaySlider.maximumValue = Float(((specificAttendee.hashCash/20)+1)*20)
        specificAttendeePaySlider.setValue(Float(specificAttendee.attendeePaidAmount), animated: true)
        specificAttendeeMinPayLbl.text = "$0"
//        specificAttendeeMaxPayLbl.text = "$\((Int(specificAttendee.hashCash/20)+1)*20)"
        specificAttendeeCurrentPayLbl.text = "$\(specificAttendee.attendeePaidAmount)"
        specificAttendeeReducedPayReason.text = specificAttendee.attendeePaidNotes
 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func sliderValueChanged(sender: UISlider) {
        let selectedValue = Int(sender.value)
        
        specificAttendeeCurrentPayLbl.text = "$" + String(stringInterpolationSegment: selectedValue)
        
        //self.trailAttendencePath.updateChildValues(["trailAttendeePaidAmt" : selectedValue])
        //self.trailsAttendedPath.updateChildValues(["hasherPaidTrailAmt" : selectedValue])
    }
    
    @IBAction func savespecificAttendeeDetails(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }

}
