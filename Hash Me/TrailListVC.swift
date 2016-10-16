//
//  FirstViewController.swift
//  Hash Me
//
//  Created by Eric Klose on 3/12/16.
//  Copyright © 2016 Eric Klose. All rights reserved.
//

import UIKit
//import Firebase

class TrailListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var trailTableView: UITableView!
    
    var trailList: TrailData!
    var trails = [TrailData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trailTableView.delegate = self
        trailTableView.dataSource = self
        trailTableView.estimatedRowHeight = 150
        
        trailList = TrailData(isFake: "fake")
        
        trailList.getTrailInfo() { () -> () in
            self.trails = self.trailList.trails
            self.trailTableView.reloadData()
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trails.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let trail: TrailData!
        trail = trails[(indexPath as NSIndexPath).row]
        
        //HOLLY'S NEW VERSION
//        performSegueWithIdentifier("trailDetails", sender: trail)
        
        //ERIC'S LEGACY VERSION
        performSegue(withIdentifier: "manageTrail", sender: trail)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return trailTableView.estimatedRowHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        trails.sort { $0.trailDate > $1.trailDate }
        let trail = trails[(indexPath as NSIndexPath).row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "trailCell") as? TrailCell {
            cell.configureCell(trail)
            return cell
        } else {
            return TrailCell()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "trailDetails" {
            if let TrailDetailsVC = segue.destination as? TrailDetailsVC {
                if let trailInCell = sender as? TrailData {
                    TrailDetailsVC.trails = trailInCell
                }
            }
        } else if segue.identifier == "manageTrail" {
            if let ManageTrailVC = segue.destination as? ManageTrailVC {
                if let trailInCell = sender as? TrailData {
                    ManageTrailVC.trails = trailInCell
                }
            }
        }
    }
}


