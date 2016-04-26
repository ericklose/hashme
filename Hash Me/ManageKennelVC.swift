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
    var mismanagementDict: Dictionary<String, AnyObject>!
    var kennelMemberDict: Dictionary<String, AnyObject>!
    
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
                if let misManDict = kennelDict["kennelMismanagement"] as? Dictionary<String, AnyObject> {
                    self.mismanagementDict = misManDict
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trails.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let trail = trails[indexPath.row]
        if let cell = tableView.dequeueReusableCellWithIdentifier("kennelTrailsCell") as? TrailCell {
            cell.configureCell(trail)
            return cell
//        } else {
//            return TrailCell()
        } else if let cell = tableView.dequeueReusableCellWithIdentifier("kennelMismanagementCell") as? MismanagementCell {
            cell.configureCell(mismanagementDict)
            return cell
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
    }
    
    func updateKennelDetails() {
        kennelNameLbl.text = kennels.kennelName
        kennelScheduleLbl.text = kennels.kennelSchedule
        kennelLocationLbl.text = kennels.kennelLocation
    }
    
}
