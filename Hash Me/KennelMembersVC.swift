//
//  KennelMembersVC.swift
//  Hash Me
//
//  Created by Eric Klose on 4/26/16.
//  Copyright © 2016 Eric Klose. All rights reserved.
//

import Firebase
import UIKit

class KennelMembersVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var kennelMembersTableView: UITableView!
    
    @IBOutlet weak var kennelNameLbl: UILabel!
    @IBOutlet weak var kennelLocationLbl: UILabel!
    @IBOutlet weak var kennelEditBtn: UIButton!
    
    var kennels: KennelData!
    var mismanagementDict: Dictionary<String, String>!
    var kennelAdminDict: Dictionary<String, AnyObject>!
    var kennelMemberDict: Dictionary<String, AnyObject>!
    var mismanagementArray = [String]()
    var kennelMemberArray = [String]()
    var relevantNameList: Dictionary<String, String> = [:]
    var userIsKennelFullAdmin: Bool = false
    var existingKennelAdmins: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        kennelMembersTableView.delegate = self
        kennelMembersTableView.dataSource = self
        
        DataService.ds.REF_KENNELS.child(kennels.kennelId).observe(.value, with: { snapshot in
            if let kennelDict = snapshot.value as? Dictionary<String, AnyObject> {
                if let misManDict = kennelDict["kennelMismanagement"] as? Dictionary<String, String> {
                    self.mismanagementDict = misManDict
                    self.mismanagementArray = [String](self.mismanagementDict.keys)
                }
                if let kMembersDict = kennelDict["kennelMembers"] as? Dictionary<String, AnyObject> {
                    self.kennelMemberDict = kMembersDict
                    self.kennelMemberArray = [String](self.kennelMemberDict.keys)
                }
                if let kAdminDict = kennelDict["kennelAdmins"] as? Dictionary<String, AnyObject> {
                    self.kennelAdminDict = kAdminDict
                    if let adminStringDict = self.kennelAdminDict as? Dictionary<String, String> {
                        self.existingKennelAdmins = adminStringDict.allKeysForValue("full").count
                    }
                    let userHasherId = DataService.ds.REF_HASHER_USERID
                    if let adminCheck = kAdminDict[userHasherId] as? String {
                        if adminCheck == "full" {
                            self.userIsKennelFullAdmin = true
                        } else {
                            self.userIsKennelFullAdmin = false
                        }
                    }
                }
            }
            DataService.ds.REF_HASHERS.observe(.value, with: { snapshot2 in
                if let snapshots2 = snapshot2.children.allObjects as? [FIRDataSnapshot] {
                    for snap2 in snapshots2 {
                        if let hasherNameDict = snap2.value as? Dictionary<String, AnyObject> {
                            let key = snap2.key
                            if let hasherHashNamesDict = hasherNameDict["hasherKennelsAndNames"] as? Dictionary<String, AnyObject> {
                                if let memberNameForThisKennel = hasherHashNamesDict[self.kennels.kennelId] {
                                    if memberNameForThisKennel as! Bool == true || memberNameForThisKennel as! String == "primary" {
                                        self.relevantNameList[key] = hasherNameDict["hasherPrimaryHashName"] as! String
                                    } else {
                                        self.relevantNameList[key] = memberNameForThisKennel as! String
                                    }
                                } else {
                                    self.relevantNameList[key] = hasherNameDict["hasherPrimaryHashName"] as! String
                                }
                            } else {
                                self.relevantNameList[key] = hasherNameDict["hasherPrimaryHashName"] as! String
                            }
                        }
                    }
                }
                self.kennelMembersTableView.reloadData()
            })
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateKennelDetails()
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kennelMemberArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if kennelMemberArray.count == 0 {
            return KennelMemberCell()
        } else {
            if let _ = mismanagementDict {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "kennelMemberCell") as? KennelMemberCell {
                    let mismanagementId = kennelMemberArray[(indexPath as NSIndexPath).row]
                    cell.configureCell(mismanagementId, memberRoleDict: mismanagementDict, memberNameDict: relevantNameList)
                    return cell
                } else {
                    return KennelMemberCell()
                }
            }
        }
        return KennelMemberCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedMemberId = kennelMemberArray[(indexPath as NSIndexPath).row]
        let selectedMemberName = relevantNameList[selectedMemberId]
        
        var selectedMemberDict: Dictionary<String, String> = ["hasherId" : selectedMemberId]
        selectedMemberDict["hasherHashName"] = selectedMemberName
        selectedMemberDict["kennelName"] = kennels.kennelName
        selectedMemberDict["kennelId"] = kennels.kennelId
        selectedMemberDict["existingFullAdmins"] = "\(existingKennelAdmins)"
        
        if let mismanDict2 = mismanagementDict {
            if let currentRole = mismanDict2[selectedMemberId]  {
                selectedMemberDict["currentRole"] = currentRole
            } else {
                selectedMemberDict["currentRole"] = ""
            }
        }
        
        if let adminDict2 = kennelAdminDict {
            if let currentAdmin = adminDict2[selectedMemberId] as? String {
                selectedMemberDict["currentAdminLevel"] = currentAdmin
            } else {
                selectedMemberDict["currentAdminLevel"] = "None"
            }
        }
        
        if userIsKennelFullAdmin == false {
            let alertController = UIAlertController(title: "Future Link to Profile", message: "just a tease for now", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
                print("you have pressed the Cancel button");
            }
            alertController.addAction(cancelAction)
            
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                print("you have pressed OK button");
            }
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true, completion:nil)
            
        } else if userIsKennelFullAdmin == true {
            let alertController = UIAlertController(title: "What Do You Want to Do", message: "because you're an admin", preferredStyle: .actionSheet)
            let profile = UIAlertAction(title: "View Member Profile", style: .default, handler: { (action) -> Void in
                print("Profile Button Pressed")
            })
            let mmRole = UIAlertAction(title: "Add/Edit Mismanagement Role", style: .default, handler: { (action) -> Void in
                
                self.performSegue(withIdentifier: "editMismanagementRole", sender: selectedMemberDict)
            })
            //            let kick = UIAlertAction(title: "Kick From Kennel", style: .Destructive) { (action) -> Void in
            //                print("Delete Button Pressed")
            //            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
                print("Cancel Button Pressed")
            }
            //            alertController.addAction(kick)
            alertController.addAction(mmRole)
            alertController.addAction(profile)
            alertController.addAction(cancel)
            
            present(alertController, animated: true, completion: nil)
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editKennel" {
            if let editKennelVC = segue.destination as? EditKennelVC {
                if let kennels = kennels as? KennelData {
                    editKennelVC.kennel = kennels
                }
            }
        }
        if segue.identifier == "manageTrail" {
            if let manageTrailVC = segue.destination as? ManageTrailVC {
                if let trailInCell = sender as? TrailData {
                    manageTrailVC.trails = trailInCell
                }
            }
        }
        if segue.identifier == "editMismanagementRole" {
            if let editMismanVC = segue.destination as? EditMismanVC {
                if let selectedMemberDict = sender {
                    editMismanVC.selectedMemberDict = selectedMemberDict as! Dictionary<String, String>
                }
            }
        }
    }
    
    func updateKennelDetails() {
        kennelNameLbl.text = kennels.kennelName
        kennelLocationLbl.text = kennels.kennelLocation
    }
    
}

