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
    @IBOutlet weak var kennelCountryLbl: UILabel!
    @IBOutlet weak var kennelUsStateLbl: UILabel!
    @IBOutlet weak var kennelEditBtn: UIButton!
    
    var kennels: KennelData!
    var trails = [TrailData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        kennelDetailsTableView.delegate = self
        kennelDetailsTableView.dataSource = self
        //trailTableView.estimatedRowHeight = 200
        
        
        DataService.ds.REF_TRAILS.observeEventType(.Value, withBlock: { snapshot in
            
            self.trails = []
            
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                for snap in snapshots {
                    if let trailDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let trail = TrailData(trailKey: key, dictionary: trailDict)
                        self.trails.append(trail)
                    }
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
        } else {
            return TrailCell()
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
    }
    
    func updateKennelDetails() {
        kennelNameLbl.text = kennels.kennelName
        kennelScheduleLbl.text = kennels.kennelSchedule
        kennelCountryLbl.text = kennels.kennelCountry
        kennelUsStateLbl.text = kennels.kennelUsState
    }
    
}
