//
//  MismanagementCell.swift
//  Hash Me
//
//  Created by Eric Klose on 4/25/16.
//  Copyright © 2016 Eric Klose. All rights reserved.
//

import UIKit

class MismanagementCell: UITableViewCell {
    
    @IBOutlet weak var MismanagementHasher: UILabel!
    @IBOutlet weak var MismanagementRole: UILabel!
    var MismanagementHasherId: String!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(hareId: String, hares: Dictionary<String, String>, hareNameDict: Dictionary<String, String>) {
        //print("c'mon", hares, hareNameDict)
        self.MismanagementHasherId = hareId
        self.MismanagementRole.text = hares[hareId]! + ": "
        self.MismanagementHasher.text = hareNameDict[hareId]
    }
    
    
}
