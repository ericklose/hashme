//
//  KennelMemberCell.swift
//  Hash Me
//
//  Created by Eric Klose on 4/26/16.
//  Copyright © 2016 Eric Klose. All rights reserved.
//

import UIKit

class KennelMemberCell: UITableViewCell {
    
    @IBOutlet weak var kennelMemberName: UILabel!
    @IBOutlet weak var kennelMemberMMRole: UILabel!
    
    var hasherId: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configureCell(hasherId: String, kennelMemberName: String, kennelMemberMMRole: String) {
        self.hasherId = hasherId
        self.kennelMemberName.text = kennelMemberName
        self.kennelMemberMMRole.text = kennelMemberMMRole
    }
    
}
