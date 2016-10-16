//
//  KennelPickerTableCell.swift
//  Hash Me
//
//  Created by Eric Klose on 4/21/16.
//  Copyright © 2016 Eric Klose. All rights reserved.
//

import UIKit

class KennelPickerTableCell: UITableViewCell {

    @IBOutlet weak var kennelName: UILabel!
    @IBOutlet weak var kennelCityAndRegion: UILabel!
    @IBOutlet weak var kennelCountryKennel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configureCell(_ kennel: KennelData) {
        self.kennelName.text = kennel.kennelName
        self.kennelCityAndRegion.text = kennel.kennelCityAndRegion
        self.kennelCountryKennel.text = "Country: " + kennel.kennelCountry
        
    }

}
