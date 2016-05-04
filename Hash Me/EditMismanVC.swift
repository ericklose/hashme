//
//  EditMismanagement.swift
//  Hash Me
//
//  Created by Eric Klose on 5/3/16.
//  Copyright © 2016 Eric Klose. All rights reserved.
//

import UIKit

class EditMismanVC: UIViewController {
    
    @IBOutlet weak var hasherHashNameLbl: UILabel!
    @IBOutlet weak var mismanagementRoleTitle: UITextField!
    @IBOutlet weak var mismanagementAdminLevel: UIButton!
    @IBOutlet weak var mismanagementRoleRemove: UIButton!
    var hasherId: String!
    var hasherHashName: String!
    var selectedMemberDict: Dictionary<String, String>!
    
    //NEDS TO INHERIT HASHER INFO FROM PRIOR VC
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //DO ALL THE .text = VARIABLE FROM THE INBOUND HASHER INFO
        
        //ALSO, FIGURE OUT HOW TO MANAGE ADMIN AND MM ROLE DATA VIA HASHER? KENNEL? FUNCTIONS
        
        //FINALLY, PROTECT AGAINST REMOVING THE FINAL ADMIN
        
        //OH, AND BUILD THE STORYBOARD AND HOOK IT ALL UP
    }
    
    @IBAction func removeMismanagementRole(sender: UIButton!) {
        let alertController = UIAlertController(title: "Remove Misman Role", message: "blah blah blah", preferredStyle: .ActionSheet)
        let remove = UIAlertAction(title: "Remove From Role", style: .Destructive, handler: { (action) -> Void in
            print("Remove Pressed")
        })
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in
            print("Cancel Button Pressed")
        }
        alertController.addAction(remove)
        alertController.addAction(cancel)
        
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func setAdminLevel(sender: UIButton!) {
        let alertController = UIAlertController(title: "Admin Level", message: "blah blah blah", preferredStyle: .ActionSheet)
        let full = UIAlertAction(title: "Full Kennel Admin", style: .Default, handler: { (action) -> Void in
            print("Full Admin Pressed")
        })
        let trail = UIAlertAction(title: "Trail Admin Only", style: .Default, handler: { (action) -> Void in
            print("Trail Admin Pressed")
        })
        let remove = UIAlertAction(title: "Remove as Admin", style: .Destructive) { (action) -> Void in
            print("Remove Admin Pressed")
        }
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in
            print("Cancel Button Pressed")
        }
        alertController.addAction(remove)
        alertController.addAction(trail)
        alertController.addAction(full)
        alertController.addAction(cancel)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
}
