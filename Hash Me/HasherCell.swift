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
    

    func configureCell(kennelMembershipId: String, kennelAndHashNameDecodeDict: Dictionary<String, String>, kennelAndNameDict: Dictionary<String, String>) {
    
        kennelNameLbl.text = kennelMembershipId
//        print("cell: \(kennelMembershipId)")
//        print("decode2: \(kennelAndHashNameDecodeDict)")
//        print("kennelandname: \(kennelAndNameDict)")
        
    
}

}