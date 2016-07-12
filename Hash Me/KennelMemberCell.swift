//
//  KennelMemberCell.swift
//  Hash Me
//
//  Created by Eric Klose on 4/26/16.
//  Copyright © 2016 Eric Klose. All rights reserved.
//

import UIKit

class KennelMemberCell: UITableViewCell {
    
    @IBOutlet weak var memberName: UILabel!
    @IBOutlet weak var memberRole: UILabel!
    var memberHasherId: String!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(memberHasherId: String, memberRoleDict: Dictionary<String, String>, memberNameDict: Dictionary<String, String>) {
        if let mmRole = memberRoleDict[memberHasherId] {
            self.memberRole.text = mmRole
        } else {
            self.memberRole.text = ""
        }
        self.memberHasherId = memberHasherId
        if let memberName = memberNameDict[memberHasherId] {
        self.memberName.text = memberName
        } else {
            self.memberName.text = "No Name"
        }
    }
}