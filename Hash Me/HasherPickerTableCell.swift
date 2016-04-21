//
//  HasherPickerTableCell.swift
//  Hash Me
//
//  Created by Eric Klose on 4/21/16.
//  Copyright © 2016 Eric Klose. All rights reserved.
//

import UIKit

class HasherPickerTableCell: UITableViewCell {
    
    @IBOutlet weak var hasherHashName: UILabel!
    @IBOutlet weak var hasherNerdName: UILabel!
    @IBOutlet weak var hasherPrimaryKennel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell(hasher: Hasher, kennelNamesDict: Dictionary<String, String>) {
        self.hasherHashName.text = hasher.hasherPrimaryHashName
        self.hasherNerdName.text = hasher.hasherNerdName
        self.hasherPrimaryKennel.text = kennelNamesDict[hasher.hasherPrimaryKennel]
        
    }
    
}
