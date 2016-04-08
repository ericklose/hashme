//
//  KennelCell.swift
//  Hash Me
//
//  Created by Eric Klose on 3/16/16.
//  Copyright © 2016 Eric Klose. All rights reserved.
//

import UIKit

class KennelCell: UITableViewCell {
    
    @IBOutlet weak var kennelName: UILabel!
    @IBOutlet weak var kennelLocation: UILabel!
    @IBOutlet weak var kennelSchedule: UILabel!
    
    var kennel: KennelData!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(kennel: KennelData) {
        self.kennel = kennel
        
        self.kennelName.text = kennel.kennelName
        self.kennelLocation.text = kennel.kennelLocation
        self.kennelSchedule.text = kennel.kennelSchedule
    }

}
