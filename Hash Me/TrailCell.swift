//
//  TrailCell.swift
//  Hash Me
//
//  Created by Eric Klose on 3/12/16.
//  Copyright © 2016 Eric Klose. All rights reserved.
//

import UIKit

class TrailCell: UITableViewCell {
    
    @IBOutlet weak var trailDate: UILabel!
    @IBOutlet weak var trailKennelName: UILabel!
    @IBOutlet weak var trailHares: UILabel!
    @IBOutlet weak var trailStartLocation: UILabel!
    @IBOutlet weak var trailDescription: UILabel!
    
    var trail: TrailData!
    var trailKennelId: String!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configureCell(_ trail: TrailData) {
        self.trail = trail
        
        self.trailDate.text = trail.trailDate
        self.trailKennelName.text = trail.trailKennelName
        self.trailKennelId = trail.trailKennelId
        self.trailStartLocation.text = trail.trailStartLocation
        self.trailDescription.text = trail.trailDescription
        self.trailHares.text = ""
        
        for (key, value) in trail.trailHares {
            let hareInitDict = ["attendeeIsHare" : true, "attendeeIsAdmin" : true]
            let hare = Attendee(attendeeInitId: key, attendeeInitDict: hareInitDict as Dictionary<String, AnyObject>, attendeeInitTrailId: trail.trailKey, attendeeInitKennelId: trail.trailKennelId, attendeeAttendingInit: true, attendeeInitTrailHashCash: trail.trailHashCash)
            hare.getRelevantHashName(key, kennelId: trail.trailKennelId) { () -> () in
                if value == "Hare" {
                    if self.trailHares.text == "" {
                        self.trailHares.text! += "\(hare.attendeeRelevantHashName)"
                    } else {
                        self.trailHares.text! += ", \(hare.attendeeRelevantHashName)"
                    }
                    //                } else if value == "Bag Car" {
                    //                    self.specificTrailBagCar.text! += "\(hare.attendeeRelevantHashName) "
                }
            }
        }
        
    }
    
}

