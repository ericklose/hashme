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
        
        DataService.ds.REF_KENNELS.childByAppendingPath(kennels.kennelId).observeEventType(.Value, withBlock: { snapshot in
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
            DataService.ds.REF_HASHERS.observeEventType(.Value, withBlock: { snapshot2 in
                if let snapshots2 = snapshot2.children.allObjects as? [FDataSnapshot] {
                    for snap2 in snapshots2 {
                        if let hasherNameDict = snap2.value as? Dictionary<String, AnyObject> {
                            let key = snap2.key
                            if let hasherHashNamesDict = hasherNameDict["hasherKennelsAndNames"] as? Dictionary<String, AnyObject> {
                                if let memberNameForThisKennel = hasherHashNamesDict[self.kennels.kennelId] {
                                    if memberNameForThisKennel as! NSObject == true || memberNameForThisKennel as! String == "primary" {
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
    
    override func viewDidAppear(animated: Bool) {
        updateKennelDetails()
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kennelMemberArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if kennelMemberArray.count == 0 {
            return KennelMemberCell()
        } else {
            if let _ = mismanagementDict {
                if let cell = tableView.dequeueReusableCellWithIdentifier("kennelMemberCell") as? KennelMemberCell {
                    let mismanagementId = kennelMemberArray[indexPath.row]
                    cell.configureCell(mismanagementId, memberRoleDict: mismanagementDict, memberNameDict: relevantNameList)
                    return cell
                } else {
                    return KennelMemberCell()
                }
            }
        }
        return KennelMemberCell()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let selectedMemberId = kennelMemberArray[indexPath.row]
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
            let alertController = UIAlertController(title: "Future Link to Profile", message: "just a tease for now", preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action:UIAlertAction!) in
                print("you have pressed the Cancel button");
            }
            alertController.addAction(cancelAction)
            
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action:UIAlertAction!) in
                print("you have pressed OK button");
            }
            alertController.addAction(OKAction)
            
            self.presentViewController(alertController, animated: true, completion:nil)
            
        } else if userIsKennelFullAdmin == true {
            let alertController = UIAlertController(title: "What Do You Want to Do", message: "because you're an admin", preferredStyle: .ActionSheet)
            let profile = UIAlertAction(title: "View Member Profile", style: .Default, handler: { (action) -> Void in
                print("Profile Button Pressed")
            })
            let mmRole = UIAlertAction(title: "Add/Edit Mismanagement Role", style: .Default, handler: { (action) -> Void in
                
                self.performSegueWithIdentifier("editMismanagementRole", sender: selectedMemberDict)
            })
            //            let kick = UIAlertAction(title: "Kick From Kennel", style: .Destructive) { (action) -> Void in
            //                print("Delete Button Pressed")
            //            }
            let cancel = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in
                print("Cancel Button Pressed")
            }
            //            alertController.addAction(kick)
            alertController.addAction(mmRole)
            alertController.addAction(profile)
            alertController.addAction(cancel)
            
            presentViewController(alertController, animated: true, completion: nil)
            
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editKennel" {
            if let editKennelVC = segue.destinationViewController as? EditKennelVC {
                if let kennels = kennels as? KennelData {
                    editKennelVC.kennel = kennels
                }
            }
        }
        if segue.identifier == "manageTrail" {
            if let manageTrailVC = segue.destinationViewController as? ManageTrailVC {
                if let trailInCell = sender as? TrailData {
                    manageTrailVC.trails = trailInCell
                }
            }
        }
        if segue.identifier == "editMismanagementRole" {
            if let editMismanVC = segue.destinationViewController as? EditMismanVC {
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

