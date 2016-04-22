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
        altHashNameTxtFld.text = kennelAndHashNameDecodeDict[kennelMembershipId]
}

    @IBAction func altHashNameEditPencilPressed(sender: AnyObject) {
        altHashNameTxtFld.hidden = false
        hashNameLbl.hidden = true
        editButton.hidden = true
        enterBtn.hidden = false
    }
    
    @IBAction func enterBtnForEditAltHashNamePressed(sender: AnyObject) {
        editAltHashNameInFirebase(altHashNameTxtFld.text, altId: kennelMembershipId)
        altHashNameTxtFld.hidden = true
        hashNameLbl.hidden = false
        editButton.hidden = false
        enterBtn.hidden = true
    }
    
    func editAltHashNameInFirebase(altName: String!, altId: String!) {
        DataService.ds.REF_HASHER_CURRENT.observeEventType(.Value, withBlock: { snapshot in
            
                    if let hasherDict = snapshot.value as? Dictionary<String, AnyObject> {
                        if let existingHashNamesDict = hasherDict["hasherKennelsAndNames"] as? Dictionary<String, AnyObject> {

                            var existingHashNamesArray = [String]()
                            for (key, value) in existingHashNamesDict {
                                if let nextName = value as? String {
                                    existingHashNamesArray.append(nextName)
                                    print("existinghashnamesarray: \(existingHashNamesArray)")
                                } 
                            }
//                        let existingHashNamesArray = existingHashNamesDict.values
//                        if existingHashNamesArray.contains(altName) || altName == nil {
//                            //do nothing
//                        } else {
//                            let kennelsAndNamesPath = Firebase(url: "\(DataService.ds.REF_HASHER_CURRENT)").childByAppendingPath("hasherKennelsAndNames")
//                            kennelsAndNamesPath.updateChildValues([altId : altName])
//                        }
                        }
                    }
                })
        
            }
    
    @IBAction func deleteKennelButtonPressed(sender: AnyObject) {
        let kennelsAndNamesPath = Firebase(url: "\(DataService.ds.REF_HASHER_CURRENT)").childByAppendingPath("hasherKennelsAndNames")
        print("kennelMembershipId: \(kennelMembershipId)")
                kennelsAndNamesPath.childByAppendingPath(kennelMembershipId as String).removeValue()
//        HasherDataVC.kennelListTableView.reloadData()
    }
    
}
