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
//    var userId = "7be00fdd-8aa6-43fe-bb6d-b53c255bab7a"
    var hasherId: String!
    var hasherDict: [String: String]!
    var thisIsTheFirstDidLoad: Bool = true
    
    //  EDGE CASE: If the entire data branch doesn't exist the app crashes ... I'm sure this could be fixed but I don't care
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("1")
        
        confirmSelectionBtn.enabled = false
        
        DataService.ds.REF_BASE.child("UidToHasherId").observeEventType(.Value, withBlock: { snapshot in
            if let userList = snapshot.value as? Dictionary<String, String> {
                print("A")
                print("AB ", KEY_UID)
                print("ABB ", NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID))
                print("AA ", self.userId)
                self.hasherDict = userList
                if let thisUsersHasherId = userList[self.userId] {
                    print("B: ")
                    DataService.ds.storeRefHasherUserId(thisUsersHasherId)
                    self.hasherId = thisUsersHasherId
                    self.performSegueWithIdentifier("fullLogIn", sender: nil)
                } else if self.hasherId == nil {
                    print("C")
                    let alertController = UIAlertController(title: "Welcome!", message: "First Check To See if Your Hash Self is Already in the System", preferredStyle: .Alert)
                    let OKAction = UIAlertAction(title: "OK", style: .Default) { (action:UIAlertAction!) in
                        self.performSegueWithIdentifier("getHasherFromTable", sender: nil)
                    }
                    alertController.addAction(OKAction)
                    self.presentViewController(alertController, animated: true, completion:nil)
                } else {
                    //No action -- this is triggered on returning from the hasher selector
                }
            }
        })
    }
    
    override func viewDidAppear(animated: Bool) {
        if thisIsTheFirstDidLoad == false {
            if let _ = hasherDict[self.userId] {
                print("JJ")
                self.performSegueWithIdentifier("fullLogIn", sender: nil)
            }
        }
        thisIsTheFirstDidLoad = false
    }
    
    @IBAction func confirmSelectionAsSelf(sender: UIButton) {
        if hasherDict.allKeysForValue(hasherId) == [] {
            DataService.ds.REF_BASE.child("UidToHasherId").updateChildValues([userId : hasherId])
        } else {
            let alertController = UIAlertController(title: "Awkward!", message: "Someone already said they're this hasher", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action:UIAlertAction!) in }
            alertController.addAction(cancelAction)
            self.presentViewController(alertController, animated: true, completion:nil)
        }
    }
    
    @IBAction func addNewHasher(sender: UIButton) {
        print("wtf: ", NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) as? String)
        print("wtf2: ", DataService.ds.REF_UID)
        print("waht's the uid here: ", userId)
        DataService.ds.REF_BASE.child("UidToHasherId").updateChildValues([userId : userId])
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
