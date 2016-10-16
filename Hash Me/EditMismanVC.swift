//
//  EditMismanagement.swift
//  Hash Me
//
//  Created by Eric Klose on 5/3/16.
//  Copyright © 2016 Eric Klose. All rights reserved.
//

import UIKit
import Firebase

class EditMismanVC: UIViewController {
    
    @IBOutlet weak var hasherHashNameLbl: UILabel!
    @IBOutlet weak var mismanagementRoleTitle: UITextField!
    @IBOutlet weak var mismanagementRoleAdminLbl: UILabel!
    @IBOutlet weak var mismanagementAdminLevel: UIButton!
    @IBOutlet weak var mismanagementRoleRemove: UIButton!
    @IBOutlet weak var mismanagementKennelName: UILabel!
    
    var adminLevel: String!
    var kennelId: String!
    var hasherId: String!
    var selectedMemberDict: Dictionary<String, String>!
    var existingFullAdmins: Int!
    
    var kennelAdminUrl: FIRDatabaseReference!
    var kennelMismanUrl: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.hideKeyboardWhenTappedAround()
        
        mismanagementRoleTitle.text = selectedMemberDict["currentRole"]
        mismanagementRoleAdminLbl.text = selectedMemberDict["currentAdminLevel"]?.capitalized
        existingFullAdmins = Int(selectedMemberDict["existingFullAdmins"]!)
        kennelId = selectedMemberDict["kennelId"]
        hasherId = selectedMemberDict["hasherId"]
        hasherHashNameLbl.text = selectedMemberDict["hasherHashName"]
        mismanagementKennelName.text = selectedMemberDict["kennelName"]
        
        kennelAdminUrl = DataService.ds.REF_KENNELS.child(kennelId).child("kennelAdmins")
        kennelMismanUrl = DataService.ds.REF_KENNELS.child(kennelId).child("kennelMismanagement")
    }
    
    @IBAction func removeMismanagementRole(_ sender: UIButton!) {
        let alertController = UIAlertController(title: "Remove Misman Role", message: "This Also Removes Admin Access", preferredStyle: .actionSheet)
        let remove = UIAlertAction(title: "Remove From Role", style: .destructive, handler: { (action) -> Void in
            self.mismanagementRoleTitle.text = ""
            self.kennelMismanUrl.child(self.hasherId).removeValue()
            self.adminLevel = ""
            self.kennelAdminUrl.child(self.hasherId).removeValue()
            self.updateDetails()
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            print("Cancel Button Pressed")
        }
        alertController.addAction(remove)
        alertController.addAction(cancel)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func changeAdminLevel(_ sender: UIButton!) {
        
        if selectedMemberDict["currentAdminLevel"] == "full" && existingFullAdmins <= 1 {
            let alertController = UIAlertController(title: "There Must Always be a Full Admin per Kennel", message: "Make Someone an Admin Before Un-Admining This Hasher", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
            }
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion:nil)
        } else {
            
            let alertController = UIAlertController(title: "Admin Level", message: "There Must Always be a Full Admin per Kennel", preferredStyle: .actionSheet)
            let full = UIAlertAction(title: "Full Kennel Admin", style: .default, handler: { (action) -> Void in
//                self.adminLevel = "full"
//                self.kennelAdminUrl.updateChildValues([self.hasherId : self.adminLevel])
//                self.updateDetails()
            })
            let trail = UIAlertAction(title: "Trail Admin Only", style: .default, handler: { (action) -> Void in
//                self.adminLevel = "trail"
//                self.kennelAdminUrl.updateChildValues([self.hasherId : self.adminLevel])
//                self.updateDetails()
            })
            let remove = UIAlertAction(title: "Remove as Admin", style: .destructive) { (action) -> Void in
//                self.adminLevel = "none"
//                self.kennelAdminUrl.child(self.hasherId).removeValue()
//                self.updateDetails()
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
                print("Cancel Button Pressed")
            }
            alertController.addAction(remove)
            alertController.addAction(trail)
            alertController.addAction(full)
            alertController.addAction(cancel)
            
            present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func doneMismanagement(_ sender: UIButton!) {
//        if mismanagementRoleTitle.text != nil && mismanagementRoleTitle.text == "" {
//            kennelMismanUrl.child(hasherId).removeValue()
//        } else if mismanagementRoleTitle.text != nil {
//            kennelMismanUrl.updateChildValues([hasherId : mismanagementRoleTitle.text!])
//        }
//        self.navigationController?.popViewController(animated: true)
    }
    
    func updateDetails() {
        mismanagementRoleAdminLbl.text = adminLevel.capitalized
    }
}
