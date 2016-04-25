//
//  HasherCell.swift
//  Hash Me
//
//  Created by Holly Klose on 4/4/16.
//  Copyright © 2016 Eric Klose. All rights reserved.
//

import UIKit
import Firebase

class HasherCell: UITableViewCell {
    
    @IBOutlet weak var kennelNameLbl: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var hashNameLbl: UILabel!
    @IBOutlet weak var altHashNameTxtFld: UITextField!
    @IBOutlet weak var enterBtn: UIButton!
    
    var kennelMembershipId: String!
    var hasherId: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configureCell(hasherId: String, kennelMembershipId: String, kennelAndHashNameDecodeDict: Dictionary<String, String>, kennelAndNameDict: Dictionary<String, String>) {
        self.hasherId = hasherId
        self.kennelMembershipId = kennelMembershipId
        kennelNameLbl.text = kennelAndNameDict[kennelMembershipId]
        hashNameLbl.text = kennelAndHashNameDecodeDict[kennelMembershipId]
        altHashNameTxtFld.text = kennelAndHashNameDecodeDict[kennelMembershipId]
    }
    
    @IBAction func altHashNameEditPencilPressed(sender: AnyObject) {
        altHashNameTxtFld.hidden = false
        hashNameLbl.hidden = true
        editButton.hidden = true
        enterBtn.hidden = false
    }
    
    @IBAction func enterBtnForEditAltHashNamePressed(sender: AnyObject) {
        editAltHashNameInFirebase(hasherId, altName: altHashNameTxtFld.text, altId: kennelMembershipId)
        altHashNameTxtFld.hidden = true
        hashNameLbl.hidden = false
        editButton.hidden = false
        enterBtn.hidden = true
    }
    
    func editAltHashNameInFirebase(hasherId: String!, altName: String!, altId: String!) {
        let kennelsAndNamesUrl = DataService.ds.REF_HASHERS.childByAppendingPath(hasherId).childByAppendingPath("hasherKennelsAndNames")
        
        if altName == "" {
            kennelsAndNamesUrl.updateChildValues([altId: true])
        } else {
            kennelsAndNamesUrl.updateChildValues([altId : altName])
        }
    }
    
    @IBAction func deleteKennelButtonPressed(sender: AnyObject) {
        let kennelsAndNamesUrl = DataService.ds.REF_HASHERS.childByAppendingPath(hasherId).childByAppendingPath("hasherKennelsAndNames")
        kennelsAndNamesUrl.childByAppendingPath(kennelMembershipId as String).removeValue()
        let kennelMembersUrl = DataService.ds.REF_KENNELS.childByAppendingPath(kennelMembershipId).childByAppendingPath("kennelMembers")
        kennelMembersUrl.childByAppendingPath(hasherId).removeValue()
    }
}
