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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configureCell(_ hasherId: String, kennelMembershipId: String, kennelAndHashNameDecodeDict: Dictionary<String, String>, kennelAndNameDict: Dictionary<String, String>) {
        self.hasherId = hasherId
        self.kennelMembershipId = kennelMembershipId
        kennelNameLbl.text = kennelAndNameDict[kennelMembershipId]
        hashNameLbl.text = kennelAndHashNameDecodeDict[kennelMembershipId]
        altHashNameTxtFld.text = kennelAndHashNameDecodeDict[kennelMembershipId]
    }
    
    @IBAction func altHashNameEditPencilPressed(_ sender: AnyObject) {
        altHashNameTxtFld.isHidden = false
        hashNameLbl.isHidden = true
        editButton.isHidden = true
        enterBtn.isHidden = false
    }
    
    @IBAction func enterBtnForEditAltHashNamePressed(_ sender: AnyObject) {
        editAltHashNameInFirebase(hasherId, altName: altHashNameTxtFld.text, altId: kennelMembershipId)
        altHashNameTxtFld.isHidden = true
        hashNameLbl.isHidden = false
        editButton.isHidden = false
        enterBtn.isHidden = true
    }
    
    func editAltHashNameInFirebase(_ hasherId: String!, altName: String!, altId: String!) {
        let kennelsAndNamesUrl = DataService.ds.REF_HASHERS.child(hasherId).child("hasherKennelsAndNames")
        
        if altName == "" {
            kennelsAndNamesUrl.updateChildValues([altId: true])
        } else {
            kennelsAndNamesUrl.updateChildValues([altId : altName])
        }
    }
    
    @IBAction func deleteKennelButtonPressed(_ sender: AnyObject) {
        let kennelsAndNamesUrl = DataService.ds.REF_HASHERS.child(hasherId).child("hasherKennelsAndNames")
        kennelsAndNamesUrl.child(kennelMembershipId as String).removeValue()
        let kennelMembersUrl = DataService.ds.REF_KENNELS.child(kennelMembershipId).child("kennelMembers")
        kennelMembersUrl.child(hasherId).removeValue()
    }
}
