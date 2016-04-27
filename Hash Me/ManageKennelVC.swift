//
//  ManageKennelVC.swift
//  Hash Me
//
//  Created by Eric Klose on 4/9/16.
//  Copyright © 2016 Eric Klose. All rights reserved.
//

import UIKit
import Firebase

class ManageKennelVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var kennelDetailsTableView: UITableView!
    
    @IBOutlet weak var kennelNameLbl: UILabel!
    @IBOutlet weak var kennelScheduleLbl: UILabel!
    @IBOutlet weak var kennelLocationLbl: UILabel!
    @IBOutlet weak var kennelEditBtn: UIButton!
    
    var kennels: KennelData!
    var trails = [TrailData]()
    var mismanagementDict: Dictionary<String, String>!
    var kennelMemberDict: Dictionary<String, AnyObject>!
    var mismanagementArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        kennelDetailsTableView.delegate = self
        kennelDetailsTableView.dataSource = self
        
        print("kennelID : ", kennels.kennelId)
        
        DataService.ds.REF_KENNELS.childByAppendingPath(kennels.kennelId).observeEventType(.Value, withBlock: { snapshot in
            
            self.trails = []
            
            if let kennelDict = snapshot.value as? Dictionary<String, AnyObject> {
                if var trailDict = kennelDict["kennelTrails"] as? Dictionary<String, AnyObject> {
                    for trail in trailDict {
                        trailDict["trailKennelId"] = self.kennels.kennelId
                        let key = trail.0
                        if let finalTrailDict = trailDict[key] as? Dictionary<String, AnyObject> {
                            let trail = TrailData(trailKey: key, dictionary: finalTrailDict)
                            self.trails.append(trail)
                        }
                    }
                }
                if let misManDict = kennelDict["kennelMismanagement"] as? Dictionary<String, String> {
                    self.mismanagementDict = misManDict
                    self.mismanagementArray = [String](self.mismanagementDict.keys)
                }
                if let kMembersDict = kennelDict["kennelMembers"] as? Dictionary<String, AnyObject> {
                    self.kennelMemberDict = kMembersDict
                }
            }
            self.kennelDetailsTableView.reloadData()
        })
    }
    
    override func viewDidAppear(animated: Bool) {
        
        updateKennelDetails()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row < trails.count {
            let trail: TrailData!
            trail = trails[indexPath.row]
            performSegueWithIdentifier("manageTrail", sender: trail)
        }
        if indexPath.row >= trails.count && indexPath.row < (trails.count+mismanagementArray.count) {
//            let kennel: KennelData!
//            kennel = kennels[indexPath.row]
            performSegueWithIdentifier("kennelMembers", sender: kennels)
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trails.count + mismanagementArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var trueRow = indexPath.row
        if trueRow < trails.count {
            if let cell = tableView.dequeueReusableCellWithIdentifier("kennelTrailsCell") as? TrailCell {
                let trail = trails[indexPath.row]
                cell.configureCell(trail)
                return cell
            } else {
                return TrailCell()
            }
        }
        
        if trueRow >= trails.count && trueRow < (trails.count+mismanagementArray.count) {
            if let cell2 = tableView.dequeueReusableCellWithIdentifier("kennelMemberCell") as? KennelMemberCell {
                let mismanagementId = mismanagementArray[(trueRow-trails.count)]
                cell2.configureCell(mismanagementId, memberRoleDict: mismanagementDict, memberNameDict: mismanagementDict)
                //cell2.configureCell(mismanagementId, misManDict: mismanagementDict)
                return cell2
            } else {
                return KennelMemberCell()
            }
        }
        return TrailCell()
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
        if segue.identifier == "kennelMembers" {
            if let kennelMembersVC = segue.destinationViewController as? KennelMembersVC {
                if let kennelPicked = kennels as? KennelData {
                    kennelMembersVC.kennels = kennelPicked
                }
            }
        }
    }
    
    func updateKennelDetails() {
        kennelNameLbl.text = kennels.kennelName
        kennelScheduleLbl.text = kennels.kennelSchedule
        kennelLocationLbl.text = kennels.kennelLocation
    }
    
}
