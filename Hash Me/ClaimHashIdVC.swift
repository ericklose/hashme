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
    
    var userId = DataService.ds.REF_UID
    var hasherId: String!
    var hasherDict: [String: String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //confirmSelectionBtn.lab = "Select A Hasher"
        confirmSelectionBtn.enabled = false
        
        DataService.ds.REF_BASE.childByAppendingPath("UidToHasherId").observeEventType(.Value, withBlock: { snapshot in
            if let userList = snapshot.value as? Dictionary<String, String> {
                self.hasherDict = userList
                if let thisUsersHasherId = userList[self.userId] {
                    DataService.ds.storeRefHasherUserId(thisUsersHasherId)
                    self.hasherId = thisUsersHasherId
                    self.performSegueWithIdentifier("fullLogIn", sender: nil)
                } else {
                    let alertController = UIAlertController(title: "Welcome!", message: "First Check To See if Your Hash Name is Already in the System", preferredStyle: .Alert)
                    let OKAction = UIAlertAction(title: "OK", style: .Default) { (action:UIAlertAction!) in
                        self.performSegueWithIdentifier("getHasherFromTable", sender: nil)
                    }
                    alertController.addAction(OKAction)
                    self.presentViewController(alertController, animated: true, completion:nil)
                }
            }
        })
    }
    
    @IBAction func confirmSelectionAsSelf(sender: UIButton) {
        if hasherDict.allKeysForValue(hasherId) == [] {
            DataService.ds.REF_BASE.childByAppendingPath("UidToHasherId").updateChildValues([userId : hasherId])
        } else {
            let alertController = UIAlertController(title: "Awkward!", message: "Someone already said they're this hasher", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action:UIAlertAction!) in }
            alertController.addAction(cancelAction)
            self.presentViewController(alertController, animated: true, completion:nil)
        }
    }
    
    @IBAction func addNewHasher(sender: UIButton) {
        DataService.ds.REF_BASE.childByAppendingPath("UidToHasherId").updateChildValues([userId : userId])
    }
    
    @IBAction func getHasherFromHasherPickerVC(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? HasherPickerTableVC {
            if sourceViewController.hasherChoiceId != nil {
                self.hasherPrimaryName.text = sourceViewController.hasherChoiceName
                self.hasherPrimaryKennel.text = "kennel"
                self.hasherId = sourceViewController.hasherChoiceId
                confirmSelectionBtn.enabled = true
            }
        }
    }
}
