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
        
        addSelfAsNewHasherBtn.enabled = false
        confirmSelectionBtn.enabled = false
        
        DataService.ds.REF_BASE.childByAppendingPath("UidToHasherId").observeEventType(.Value, withBlock: { snapshot in
            if let userList = snapshot.value as? Dictionary<String, String> {
                if let thisUsersHasherId = userList[DataService.ds.REF_HASHER_USERID] {
                    self.hasherId = thisUsersHasherId
                    self.performSegueWithIdentifier("fullLogIn", sender: nil)
                } else {
                    let alertController = UIAlertController(title: "Welcome!", message: "Get Eric or Holly to set you up", preferredStyle: .Alert)
                    
                    let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action:UIAlertAction!) in
                        print("you have pressed the Cancel button");
                    }
                    alertController.addAction(cancelAction)
                    
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
        //make the person search for what might be them
        //confirm this is you
        //connect the Ids OR
        //pop an alert that someone claimed it
        
    }
    
    @IBAction func getHasherFromHasherPickerVC(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? HasherPickerTableVC {
            if sourceViewController.hasherChoiceId != nil {
                self.hasherPrimaryName.text = sourceViewController.hasherChoiceName
                self.hasherPrimaryKennel.text = "working on it"
                self.hasherId = sourceViewController.hasherChoiceId
                confirmSelectionBtn.enabled = true
            } else if sourceViewController.hasherChoiceId == nil {
                addSelfAsNewHasherBtn.enabled = true
            }
        }
    }
}
