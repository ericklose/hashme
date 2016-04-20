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
    //DELETE EDIT BUTTN OUTLET? DON't DELETE...NEED TO HIDE WHEN EDITING/ADDING ALT HASH NAME
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

//    @IBAction func altHashNameEditPencilPressed(sender: AnyObject) {
//        //CALL IN UPDATE BUTTON
//        
//        altHashNameTxtFld.hidden = false
//        altHashNameLbl.hidden = true
//        editButton.hidden = true
//        updateInfoBtn.hidden = false
        
//
//    }
    
    func editAltHashNameInFirebase(altName: String!, altId: String!) {
        DataService.ds.REF_HASHER_CURRENT.observeEventType(.Value, withBlock: { snapshot in
            
                    if let hasherDict = snapshot.value as? Dictionary<String, AnyObject> {
                        let existingHashNamesDict = hasherDict["hasherKennelsAndNames"] as? Dictionary<String, String>
                        let existingHashNamesArray = existingHashNamesDict!.values
                        if existingHashNamesArray.contains(altName) || altName == nil {
                            //do nothing
                        } else {
//                            let kennelsAndNamesPath = Firebase(url: "\(DataService.ds.REF_HASHER_CURRENT)").childByAppendingPath("hasherKennelsAndNames")
//                            kennelsAndNamesPath.updateChildValues([altId : altName])
                        }
            
                    }
                })
        
            }
    
}
