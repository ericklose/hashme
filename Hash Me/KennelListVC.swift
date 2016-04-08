//
//  KennelListVC.swift
//  Hash Me
//
//  Created by Eric Klose on 3/16/16.
//  Copyright © 2016 Eric Klose. All rights reserved.
//

import UIKit
import Firebase

class KennelListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var kennelListTable: UITableView!
    @IBOutlet weak var newKennelName: UITextField!
    @IBOutlet weak var newKennelCountry: UITextField!
    @IBOutlet weak var newKennelUsState: UITextField!
    
    var kennels = [KennelData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        kennelListTable.delegate = self
        kennelListTable.dataSource = self
        kennelListTable.estimatedRowHeight = 100
        
        DataService.ds.REF_KENNELS.observeEventType(.Value, withBlock: { snapshot in
            
            self.kennels = []
            
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                
                for snap in snapshots {
                    
                    if let kennelDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let kennelName = kennelDict["name"] as? String
                        let kennel = KennelData(kennelInitId: key, kennelInitDict: kennelDict, kennelInitName: kennelName!)
                        self.kennels.append(kennel)
                    }
                }
                
            }
            
            self.kennelListTable.reloadData()
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kennels.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let kennel: KennelData!
        kennel = kennels[indexPath.row]
        performSegueWithIdentifier("manageKennel", sender: kennel)
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return kennelListTable.estimatedRowHeight
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let kennel = kennels[indexPath.row]
        if let cell = tableView.dequeueReusableCellWithIdentifier("kennelCell") as? KennelCell {
            cell.configureCell(kennel)
            return cell
        } else {
            return KennelCell()
        }
        
    }


    @IBAction func addNewKennel(sender: UIButton) {
        
    }

}
