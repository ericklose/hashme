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
    
    func configureCell(misManHasherId: String, misManDict: Dictionary<String, String>) {
        print("tester: ", misManHasherId)
        print("tester2: ", misManDict)
        self.MismanagementHasherId = misManHasherId
        self.MismanagementRole.text = misManDict[misManHasherId]!
        self.MismanagementHasher.text = misManHasherId
    }
    
    
}
