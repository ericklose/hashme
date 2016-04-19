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
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var hashNameLbl: UILabel!
    
    var kennelMembershipId: String!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(kennelMembershipId: String, kennelAndHashNameDecodeDict: Dictionary<String, String>, kennelAndNameDict: Dictionary<String, String>) {
        
        self.kennelMembershipId = kennelMembershipId
        kennelNameLbl.text = kennelAndNameDict[kennelMembershipId]
        hashNameLbl.text = kennelAndHashNameDecodeDict[kennelMembershipId]
}

}