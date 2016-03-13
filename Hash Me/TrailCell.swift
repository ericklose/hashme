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
    @IBOutlet weak var trailKennel: UILabel!
    @IBOutlet weak var trailHares: UILabel!
    @IBOutlet weak var trailStartLocation: UILabel!
    @IBOutlet weak var trailDescription: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
