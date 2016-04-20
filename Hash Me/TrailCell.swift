//
//  TrailCell.swift
//  Hash Me
//
//  Created by Eric Klose on 3/12/16.
//  Copyright © 2016 Eric Klose. All rights reserved.
//

import UIKit
import Alamofire
import Firebase

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
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configureCell(trail: TrailData) {
        self.trail = trail
        
        self.trailDate.text = trail.trailDate
        self.trailKennelName.text = trail.trailKennelName
        self.trailKennelId = trail.trailKennelId
        //self.trailHares.text = trail.trailHares
        self.trailStartLocation.text = trail.trailStartLocation
        self.trailDescription.text = trail.trailDescription
        
    }
    
}

