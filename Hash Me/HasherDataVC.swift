//
//  SecondViewController.swift (changed to HasherDataVC)
//  Hash Me
//
//  Created by Eric Klose on 3/12/16.
//  Copyright © 2016 Eric Klose. All rights reserved.
//

import UIKit
import Firebase

class HasherDataVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var nerdNameLbl: UILabel!
    @IBOutlet weak var nerdNameTxtFld: UITextField!
    @IBOutlet weak var updateInfoBtn: UIButton!
    @IBOutlet weak var nerdNamePencil: UIButton!
    @IBOutlet weak var kennelListTableView: UITableView!
    
    var hasherDict: Dictionary<String, AnyObject>!
    var hasher: Hasher!
    var kennelAndNameDict: [String: String] = [:]
    var kennelAndHashNameDecodeDict: [String: String] = [:]
    var kennelMembershipIds = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.kennelListTableView.dataSource = self
        self.kennelListTableView.delegate = self
        
        
        downloadHasherDetails { () -> () in
            self.updateHasherDisplay()
        }
    }
    
    func updateHasherDisplay() {
        self.nerdNameLbl.text = self.hasher.hasherNerdName
        self.nerdNameTxtFld.text = self.hasher.hasherNerdName
        kennelListTableView.reloadData()
    }
    
    func downloadHasherDetails(completed: DownloadComplete) {
        DataService.ds.REF_HASHER_CURRENT.observeEventType(.Value, withBlock: { snapshot in
            
            if var hasherDict = snapshot.value as? Dictionary<String, AnyObject>{
                DataService.ds.REF_KENNELS.observeEventType(.Value, withBlock: { snapshot in
                    //                    if let kennelDict = snapshot.value as? Dictionary<String, AnyObject> {
                    if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                        
                        for snap in snapshots {
                            
                            if let kennelDict2 = snap.value as? Dictionary<String, AnyObject> {
                                let key = snap.key
                                let name = kennelDict2["name"]!
                                self.kennelAndNameDict[key] = (name as! String)
                            }
                        }
                    }
                    //                    }
                    
                    hasherDict["addedKennelDict"] = self.kennelAndNameDict
                    
                    self.hasher = Hasher(hasherInitId: KEY_UID, hasherInitDict: hasherDict)
                    
                    if let hashNamesAndKennels = hasherDict["hasherKennelsAndNames"] as? Dictionary<String, AnyObject> {
                        
                        for (key, value) in hashNamesAndKennels {
                            
                            if value as? String == "primary" {
                                //take primary kennel and hashname out of table
                                
                            } else if value as! NSObject == true {
                                self.kennelAndHashNameDecodeDict[key] = ""
                                
                            }else {
                                self.kennelAndHashNameDecodeDict[key] = (value as! String)
                            }
                            
                        }
                        
                    }
                    self.kennelMembershipIds = [String](self.kennelAndHashNameDecodeDict.keys)
                    
                    completed()
                })
            }
            
        })
        
    }
    
    func editNerdNameInFirebase(nerdName: String!) {
        
        DataService.ds.REF_HASHER_CURRENT.observeEventType(.Value, withBlock: { snapshot in
            
            if let hasherDict = snapshot.value as? Dictionary<String, AnyObject> {
                let existingNerdName = hasherDict["hasherNerdName"] as! String
                
                if nerdName != existingNerdName && nerdName != "" {
                    let namePath = Firebase(url: "\(DataService.ds.REF_HASHER_CURRENT)")
                    
                    namePath.updateChildValues(["hasherNerdName" : nerdName])
                }
            }
        })
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func editNerdNamePressed(sender: AnyObject) {
        nerdNameTxtFld.hidden = false
        nerdNameLbl.hidden = true
        nerdNamePencil.hidden = true
        updateInfoBtn.hidden = false
        
    }
    
    @IBAction func updateInfoPressed(sender: AnyObject) {
        editNerdNameInFirebase(nerdNameTxtFld.text)
        
        nerdNameTxtFld.hidden = true
        updateInfoBtn.hidden = true
        nerdNamePencil.hidden = false
        nerdNameLbl.hidden = false
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kennelMembershipIds.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 30
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let kennelMembershipId = kennelMembershipIds[indexPath.row]
        if let cell = tableView.dequeueReusableCellWithIdentifier("hasherCell") as? HasherCell {
            cell.configureCell(kennelMembershipId, kennelAndHashNameDecodeDict: kennelAndHashNameDecodeDict, kennelAndNameDict: kennelAndNameDict)
            return cell
        } else {
            return HasherCell()
        }
        
    }
    
    @IBAction func kennelAndHashNameBtnPressed(sender: AnyObject) {
    }
    
    @IBAction func getKennelFromKennelPickerVC(sender: UIStoryboardSegue) {
        
        if let sourceViewController = sender.sourceViewController as? KennelPickerVC {
            
            let hasherKennelsArray = kennelAndHashNameDecodeDict.keys
            
            let hasherTrailsAndNames = Firebase(url: "\(DataService.ds.REF_HASHER_CURRENT)").childByAppendingPath("hasherKennelsAndNames")
            
            if sourceViewController.kennelChoiceId == nil || hasherKennelsArray.contains(sourceViewController.kennelChoiceId) {
        
            } else {
                    hasherTrailsAndNames.updateChildValues([sourceViewController.kennelChoiceId! : true])
            }
        }
    }
    
    @IBAction func editPrimaryKennelNamePressed(sender: AnyObject) {
    }
    
    
    @IBAction func editPrimaryHashNamePressed(sender: AnyObject) {
    }
    
    
    @IBAction func deleteHashKennelBtnPressed(sender: AnyObject) {
    }
    
}

