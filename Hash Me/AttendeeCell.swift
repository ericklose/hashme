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
    
    var attendee: Hasher!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(attendee: Hasher) {
        self.attendee = attendee
        
        self.hasherNerdName.text = attendee.hasherNerdName
     // *****NEED TO FIX NOW THAT DATA STRUCTURE OF HASHERHASHNAMES IS DIFFERENT
    //    self.hasherHashNames.text = attendee.hasherHashNames
        self.hasherPresent.on = true
        self.hasherIsVirgin.on = false
        self.hasherIsVisitor.on = false
        self.hasherPaidFull.on = false
        self.hasherVirginSponsorIs.text = ""
        self.hasherVisitorFrom.text = ""
        self.hasherPaidReduced.value = 10
        self.hasherPaidReducedReason.text = "various reasons"
        
    }

}
