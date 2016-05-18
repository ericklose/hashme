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
    }
    
    @IBAction func changeUserPassword(sender: AnyObject) {
    }
    
    @IBAction func changeUserEmail(sender: AnyObject) {
    }

    @IBAction func hideNerdName(sender: AnyObject) {
    }
    
}
