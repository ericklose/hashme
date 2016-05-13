//
//  ClaimHashIdVC.swift
//  Hash Me
//
//  Created by Eric Klose on 5/11/16.
//  Copyright © 2016 Eric Klose. All rights reserved.
//

import UIKit
import Firebase

class ClaimHashIdVC: UIViewController {
    
    @IBOutlet weak var hasherPrimaryName: UILabel!
    @IBOutlet weak var hasherPrimaryKennel: UILabel!
    @IBOutlet weak var lookForAHasherBtn: UIButton!
    @IBOutlet weak var confirmSelectionBtn: UIButton!
    @IBOutlet weak var addSelfAsNewHasherBtn: UIButton!
    
    var userId: String!
    var hasherId: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSelfAsNewHasherBtn.userInteractionEnabled = false
        confirmSelectionBtn.userInteractionEnabled = false
        
        DataService.ds.REF_BASE.childByAppendingPath("UidToHasherId").observeEventType(.Value, withBlock: { snapshot in
            if let userList = snapshot.value as? Dictionary<String, String> {
                if let thisUsersHasherId = userList[DataService.ds.REF_HASHER_USERID] {
                    self.hasherId = thisUsersHasherId
                    print("ID IS ", self.hasherId)
                    //do segue to the next screen
                } else {
                    //POP UP: This login is not associated with a hash identity -- see if you're in the system and if not, add yourself
                    //Execute getHasherFromHasherPicker
                }
            }
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //prepare to hand off to hasher picker
    }
    
    
    @IBAction func lookForAHasher(sender: UIButton) {
    }
    
    @IBAction func confirmSelectionAsSelf(sender: UIButton) {
        
    }
    
    @IBAction func getHasherFromHasherPicker(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? HasherPickerVC {
            if sourceViewController.hasherChoiceId != nil {
//                self.hasherChoiceId = sourceViewController.hasherChoiceId
//                newHasherIsSelected = true
                confirmSelectionBtn.userInteractionEnabled = true
            } else if sourceViewController.hasherChoiceId == nil {
                addSelfAsNewHasherBtn.userInteractionEnabled = true
            }
        }
    }
    
    
    func claimHasher() {
        //make the person search for what might be them
        //confirm this is you
        //connect the Ids OR
        //pop an alert that someone claimed it
    }
    
}
