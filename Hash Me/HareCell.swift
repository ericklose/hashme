//
//  HareCell.swift
//  Hash Me
//
//  Created by Eric Klose on 4/20/16.
//  Copyright © 2016 Eric Klose. All rights reserved.
//

import UIKit

class HareCell: UITableViewCell {

    @IBOutlet weak var hareName: UILabel!
    @IBOutlet weak var roleTitle: UILabel!
    var hareId: String!


    override func awakeFromNib() {
        super.awakeFromNib()
        //Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(_ hareId: String, hares: Dictionary<String, String>, hareNameDict: Dictionary<String, String>) {
        //print("c'mon", hares, hareNameDict)
        self.hareId = hareId
        self.roleTitle.text = hares[hareId]! + ": "
        self.hareName.text = hareNameDict[hareId]
    }
    
    
}
