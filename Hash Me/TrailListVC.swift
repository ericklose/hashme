//
//  FirstViewController.swift
//  Hash Me
//
//  Created by Eric Klose on 3/12/16.
//  Copyright © 2016 Eric Klose. All rights reserved.
//

import UIKit
import Firebase

class TrailListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var trailTableView: UITableView!
    
    var trails = [TrailData]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trailTableView.delegate = self
        trailTableView.dataSource = self
        trailTableView.estimatedRowHeight = 150
        
        //CREATE HASHER ID TO HASHER DICT AND PASS TO TRAIL CELL (VIA CONFIGURE CELL)
        
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
            self.trailTableView.reloadData()
        })
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trails.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let trail: TrailData!
        trail = trails[indexPath.row]
        
        //HOLLY'S NEW VERSION
        //performSegueWithIdentifier("trailDetails", sender: trail)
        
        //ERIC'S LEGACY VERSION
        performSegueWithIdentifier("manageTrail", sender: trail)
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return trailTableView.estimatedRowHeight
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        trails.sortInPlace { $0.trailDate > $1.trailDate }
        let trail = trails[indexPath.row]
        if let cell = tableView.dequeueReusableCellWithIdentifier("trailCell") as? TrailCell {
            cell.configureCell(trail)
            return cell
        } else {
            return TrailCell()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "trailDetails" {
            if let TrailDetailsVC = segue.destinationViewController as? TrailDetailsVC {
                if let trailInCell = sender as? TrailData {
                    TrailDetailsVC.trails = trailInCell
                }
            }
        } else if segue.identifier == "manageTrail" {
            if let ManageTrailVC = segue.destinationViewController as? ManageTrailVC {
                if let trailInCell = sender as? TrailData {
                    ManageTrailVC.trails = trailInCell
                }
            }
        }
    }
}


