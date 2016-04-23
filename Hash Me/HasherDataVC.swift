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
    @IBOutlet weak var primaryHashNameTxtFld: UITextField!
    @IBOutlet weak var primaryHashNameLbl: UILabel!
    @IBOutlet weak var primaryHashNamePencil: UIButton!
    @IBOutlet weak var primaryKennelNameLbl: UILabel!
    
    var hasherDict: Dictionary<String, AnyObject>!
    var hasher: Hasher!
    var kennelAndNameDict: [String: String] = [:]
    var kennelAndHashNameDecodeDict: [String: String] = [:]
    var kennelMembershipIds = [String]()
    var kennelMembershipId = String!.self
    var hasherKennelIdsAndNamesDict: [String: String] = [:]
    var hasherPrimaryKennel: String!
    
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
        self.primaryHashNameLbl.text = self.hasher.hasherPrimaryHashName
        self.primaryHashNameTxtFld.text = self.hasher.hasherPrimaryHashName
        self.primaryKennelNameLbl.text = kennelAndNameDict[hasher.hasherPrimaryKennel]
        self.hasherPrimaryKennel = self.hasher.hasherPrimaryKennel
        
        kennelListTableView.reloadData()
    }
    
    func downloadHasherDetails(completed: DownloadComplete) {
        DataService.ds.REF_HASHER_CURRENT.observeEventType(.Value, withBlock: { snapshot in
            
            self.kennelMembershipIds = []
            self.kennelAndHashNameDecodeDict = [:]
            self.kennelAndNameDict = [:]
            
            if var hasherDict = snapshot.value as? Dictionary<String, AnyObject>{
                DataService.ds.REF_KENNELS.observeEventType(.Value, withBlock: { snapshot in
                    if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                        for snap in snapshots {
                            if let kennelDict2 = snap.value as? Dictionary<String, AnyObject> {
                                let key = snap.key
                                let name = kennelDict2["kennelName"]!
                                self.kennelAndNameDict[key] = (name as! String)
                            }
                        }
                    }
                    hasherDict["addedKennelDict"] = self.kennelAndNameDict
                    self.hasher = Hasher(hasherInitId: KEY_UID, hasherInitDict: hasherDict)
                    self.kennelAndHashNameDecodeDict = [:]
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
    
    @IBAction func editNerdNamePressed(sender: AnyObject) {
        nerdNameTxtFld.hidden = false
        nerdNameLbl.hidden = true
        nerdNamePencil.hidden = true
        updateInfoBtn.hidden = false
    }
    
    func editNerdNameInFirebase(nerdName: String!) {
        let namePath = Firebase(url: "\(DataService.ds.REF_HASHER_CURRENT)")
        
        if nerdName != "" {
            namePath.updateChildValues(["hasherNerdName" : nerdName])
        } else {
            namePath.childByAppendingPath("hasherNerdName").removeValue()
        }
    }
    
    func editPrimaryHashNameInFirebase(primaryName: String!) {
        
        DataService.ds.REF_HASHER_CURRENT.observeEventType(.Value, withBlock: { snapshot in
            
            if let hasherDict = snapshot.value as? Dictionary<String, AnyObject> {
                let existingPrimaryName = hasherDict["hasherPrimaryHashName"] as! String
                if primaryName != existingPrimaryName && primaryName != "" {
                    let namePath = Firebase(url: "\(DataService.ds.REF_HASHER_CURRENT)")
                    namePath.updateChildValues(["hasherPrimaryHashName" : primaryName])
                }
            }
        })
    }
    
    @IBAction func updateInfoPressed(sender: AnyObject) {
        editNerdNameInFirebase(nerdNameTxtFld.text)
        editPrimaryHashNameInFirebase(primaryHashNameTxtFld.text)
        
        nerdNameTxtFld.hidden = true
        updateInfoBtn.hidden = true
        nerdNamePencil.hidden = false
        nerdNameLbl.hidden = false
        primaryHashNameTxtFld.hidden = true
        primaryHashNameLbl.hidden = false
        primaryHashNamePencil.hidden = false
        
        updateInfoBtn.hidden = true
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
    //TABLE to add new kennels
    @IBAction func getKennelFromKennelPickerVC(sender: UIStoryboardSegue) {
        
        if let sourceViewController = sender.sourceViewController as? KennelPickerTableVC {
            let hasherKennelsArray = kennelAndHashNameDecodeDict.keys
            let hasherTrailsAndNamesUrl = Firebase(url: "\(DataService.ds.REF_HASHER_CURRENT)").childByAppendingPath("hasherKennelsAndNames")
            
            if sourceViewController.kennelChoiceId != nil && !hasherKennelsArray.contains(sourceViewController.kennelChoiceId) {
                hasherTrailsAndNamesUrl.updateChildValues([sourceViewController.kennelChoiceId! : true])
                let kennelMembersUrl = Firebase(url: "\(DataService.ds.REF_KENNELS)").childByAppendingPath(sourceViewController.kennelChoiceId).childByAppendingPath("kennelMembers")
                kennelMembersUrl.updateChildValues([NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) as! String : true])
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "pickHasherPrimaryKennel" {
            if let KennelPickerVC = segue.destinationViewController as? KennelPickerVC {
                
                let hasherKennelsArray = kennelAndHashNameDecodeDict.keys
                for key in hasherKennelsArray {
                    self.hasherKennelIdsAndNamesDict[kennelAndNameDict[key]!] = key
                }
                print("dictinhashervc", hasherKennelIdsAndNamesDict)
                KennelPickerVC.hasherKennelIdsAndNamesDict = hasherKennelIdsAndNamesDict
            }
        }
    }
    
    //PICKER to select/change primary kennel
    @IBAction func getKennelFromOriginalKennelPicker(sender: UIStoryboardSegue) {
        
        if let sourceViewController = sender.sourceViewController as? KennelPickerVC {
            let primaryKennelUrl = Firebase(url: "\(DataService.ds.REF_HASHER_CURRENT)")
            let hasherKennelsAndNamesUrl = Firebase(url: "\(DataService.ds.REF_HASHER_CURRENT)").childByAppendingPath("hasherKennelsAndNames")
            
            if sourceViewController.kennelChoiceId != nil {
                if hasherPrimaryKennel != nil {
                    hasherKennelsAndNamesUrl.updateChildValues([hasherPrimaryKennel as! String: true])
                }
                primaryKennelUrl.updateChildValues(["hasherPrimaryKennel" : sourceViewController.kennelChoiceId!])
                hasherKennelsAndNamesUrl.updateChildValues([sourceViewController.kennelChoiceId : "primary"])
            }
            //MAYBE SIMPLIFY LATER. IS ELSE NECESSARY?
        }
    }
    
    @IBAction func editPrimaryHashNamePressed(sender: AnyObject) {
        primaryHashNameTxtFld.hidden = false
        primaryHashNameLbl.hidden = true
        primaryHashNamePencil.hidden = true
        updateInfoBtn.hidden = false
    }
    
}
