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
        self.hideKeyboardWhenTappedAround() 
        
        kennelDetailsTableView.delegate = self
        kennelDetailsTableView.dataSource = self
        
        DataService.ds.REF_KENNELS.child(kennels.kennelId).observe(.value, with: { snapshot in
            
            self.trails = []
            
            if let kennelDict = snapshot.value as? Dictionary<String, AnyObject> {
                if var trailDict = kennelDict["kennelTrails"] as? Dictionary<String, AnyObject> {
                    for trail in trailDict {
                        trailDict["trailKennelId"] = self.kennels.kennelId as AnyObject?
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
    
    override func viewDidAppear(_ animated: Bool) {
        
        updateKennelDetails()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath as NSIndexPath).row < trails.count {
            let trail: TrailData!
            trail = trails[(indexPath as NSIndexPath).row]
            performSegue(withIdentifier: "manageTrail", sender: trail)
        }
        if (indexPath as NSIndexPath).row >= trails.count && (indexPath as NSIndexPath).row < (trails.count+mismanagementArray.count) {
//            let kennel: KennelData!
//            kennel = kennels[indexPath.row]
            performSegue(withIdentifier: "kennelMembers", sender: kennels)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trails.count + mismanagementArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let trueRow = (indexPath as NSIndexPath).row
        if trueRow < trails.count {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "kennelTrailsCell") as? TrailCell {
                trails.sort { $0.trailDate > $1.trailDate }
                let trail = trails[(indexPath as NSIndexPath).row]
                cell.configureCell(trail)
                return cell
            } else {
                return TrailCell()
            }
        }
        
        if trueRow >= trails.count && trueRow < (trails.count+mismanagementArray.count) {
            if let cell2 = tableView.dequeueReusableCell(withIdentifier: "kennelMemberCell") as? KennelMemberCell {
                let mismanagementId = mismanagementArray[(trueRow-trails.count)]
                cell2.configureCell(mismanagementId, memberRoleDict: mismanagementDict, memberNameDict: mismanagementDict)
                return cell2
            } else {
                return KennelMemberCell()
            }
        }
        return TrailCell()
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
        if segue.identifier == "kennelMembers" {
            if let kennelMembersVC = segue.destination as? KennelMembersVC {
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
