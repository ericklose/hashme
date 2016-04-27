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
    var kennelMemberDict: Dictionary<String, AnyObject>!
    var mismanagementArray = [String]()
    var kennelMemberArray = [String]()
    var relevantNameList: Dictionary<String, String> = [:]
    
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
        print("CELLCOUNT: ", kennelMemberArray.count)
        return kennelMemberArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print("KMA: ", kennelMemberDict)
        print("MMCELL: ",mismanagementArray)
                print("RNL: ", relevantNameList)
        if let cell = tableView.dequeueReusableCellWithIdentifier("kennelMemberCell") as? KennelMemberCell {
            let mismanagementId = kennelMemberArray[indexPath.row]
            cell.configureCell(mismanagementId, memberRoleDict: mismanagementDict, memberNameDict: relevantNameList)
            return cell
        } else {
            return KennelMemberCell()
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
    }
    
    func updateKennelDetails() {
        kennelNameLbl.text = kennels.kennelName
        kennelLocationLbl.text = kennels.kennelLocation
    }
    
}
