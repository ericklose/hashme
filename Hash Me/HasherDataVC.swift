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
        kennelListTableView.reloadData()
    }
    
    func downloadHasherDetails(completed: DownloadComplete) {
        DataService.ds.REF_HASHER_CURRENT.observeEventType(.Value, withBlock: { snapshot in
            
            self.kennelMembershipIds = []
            self.kennelAndHashNameDecodeDict = [:]
            print("confirm blank: ", self.kennelMembershipIds)
            
            if var hasherDict = snapshot.value as? Dictionary<String, AnyObject>{
                print("1")
                DataService.ds.REF_KENNELS.observeEventType(.Value, withBlock: { snapshot in
                   print("1A")
                    //                    if let kennelDict = snapshot.value as? Dictionary<String, AnyObject> {
                    if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                     print("2")
                        for snap in snapshots {
                         print("3")
                            if let kennelDict2 = snap.value as? Dictionary<String, AnyObject> {
                                print("4")
                                let key = snap.key
                                let name = kennelDict2["name"]!
                                self.kennelAndNameDict[key] = (name as! String)
                            }
                        }
                    }
                    //                    }
                    print("5")
                    hasherDict["addedKennelDict"] = self.kennelAndNameDict
                    self.hasher = Hasher(hasherInitId: KEY_UID, hasherInitDict: hasherDict)
                    if let hashNamesAndKennels = hasherDict["hasherKennelsAndNames"] as? Dictionary<String, AnyObject> {
                        print("6")
                        for (key, value) in hashNamesAndKennels {
                            print("7")
                            if value as? String == "primary" {
                                //take primary kennel and hashname out of table
                            } else if value as! NSObject == true {
                                self.kennelAndHashNameDecodeDict[key] = ""
                            }else {
                                self.kennelAndHashNameDecodeDict[key] = (value as! String)
                            }
                        }
                    }
                    print("confirm: ", self.kennelAndHashNameDecodeDict.keys)
                    self.kennelMembershipIds = [String](self.kennelAndHashNameDecodeDict.keys)
                    print("confirm2: ", self.kennelMembershipIds)

                    completed()
                })
            }
//            print("confirmXXX: ", self.kennelAndHashNameDecodeDict.keys)
//            self.kennelMembershipIds = [String](self.kennelAndHashNameDecodeDict.keys)
//            print("confirm2XXX: ", self.kennelMembershipIds)
            
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
                //                let existingPrimaryKennel = hasherDict["hasherPrimaryKennel"] as! String
                
                if primaryName != existingPrimaryName && primaryName != "" {
                    let namePath = Firebase(url: "\(DataService.ds.REF_HASHER_CURRENT)")
                    namePath.updateChildValues(["hasherPrimaryHashName" : primaryName])
                    
                    //                    let kennelsAndNamesPath = Firebase(url: "\(DataService.ds.REF_HASHER_CURRENT)").childByAppendingPath("hasherKennelsAndNames")
                    //                    kennelsAndNamesPath.updateChildValues([existingPrimaryKennel : "primary"])
                    
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
        print("KMIs ", kennelMembershipIds)
        print("KMI count ", kennelMembershipIds.count)
        let kennelMembershipId = kennelMembershipIds[indexPath.row]
        print("KMI ", kennelMembershipId)

        if let cell = tableView.dequeueReusableCellWithIdentifier("hasherCell") as? HasherCell {
            cell.configureCell(kennelMembershipId, kennelAndHashNameDecodeDict: kennelAndHashNameDecodeDict, kennelAndNameDict: kennelAndNameDict)
            return cell
        } else {
            return HasherCell()
        }
        
    }
    
    @IBAction func getKennelFromKennelPickerVC(sender: UIStoryboardSegue) {
        
        if let sourceViewController = sender.sourceViewController as? KennelPickerTableVC {
            if sourceViewController.kennelChoiceId == nil {
            } else {
                let kName = sourceViewController.kennelChoiceName
                let kId = sourceViewController.kennelChoiceId
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //IF SEGUE == SELECT YOUR HOME KENNEL (NEEDS IDENTIFIER)
        //SEND OVER THE CURRENT KENNEL LIST (DO YOU GRAB IT FROM THE OTHER SEGUE AS A SOURCE VIEW CONTROLLER OR SHIP IT AS THE PREPARE FOR SEGUE?)
        //THIS SHOULD USE THE PICKER NOT THE TABLE SINCE IT'S COOLER TO HAVE VARIETY AND KEEPS IT EASY ON WHICH VC IS SENDING DATA BACK
    }
    
    @IBAction func getKennelFromOriginalKennelPicker(sender: UIStoryboardSegue) {
        
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
        primaryHashNameTxtFld.hidden = false
        primaryHashNameLbl.hidden = true
        primaryHashNamePencil.hidden = true
        updateInfoBtn.hidden = false
    }
    
    
}

