//
//  UserPreferencesVC.swift
//  Hash Me
//
//  Created by Eric Klose on 5/18/16.
//  Copyright © 2016 Eric Klose. All rights reserved.
//

import UIKit

class UserPreferencesVC: UIViewController {
    
    @IBOutlet weak var hideNerdNameToggle: UISwitch!
    @IBOutlet weak var logoutUserBtn: UIButton!
    @IBOutlet weak var changePasswordBtn: UIButton!
    @IBOutlet weak var changeEmailBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func logoutUser(sender: AnyObject) {
//         Doesn't work but needs IBAction hooked up
//        logoutFirebase()
    }
    
    @IBAction func changeUserPassword(sender: AnyObject) {
        //Need to get user email and existing password to here somehow
//        FirebaseUserSettings.fus.changeFirebasePassword(String, pwd: String)
//        changeFirebasePassword("email", pwd: "current password")
    }
    
    @IBAction func changeUserEmail(sender: AnyObject) {
    }

    @IBAction func hideNerdName(sender: AnyObject) {
        showErrorAlert("I don't know how to do this yet", msg: "But later it'll hide your nerd name from other users for privacy")
    }
    
}
