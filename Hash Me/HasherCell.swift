//
//  HasherCell.swift
//  Hash Me
//
//  Created by Holly Klose on 4/4/16.
//  Copyright © 2016 Eric Klose. All rights reserved.
//

import UIKit

class HasherCell: UITableViewCell {
    
    @IBOutlet weak var kennelNameLbl: UILabel!
    @IBOutlet weak var deleteXButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(kennel: KennelData) {
        kennelNameLbl.text = kennel.kennelName
        print("kennelName: \(kennel.kennelName)")
        
    }

}
