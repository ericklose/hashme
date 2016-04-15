//
//  SecondViewController.swift (changed to HasherDataVC)
//  Hash Me
//
//  Created by Eric Klose on 3/12/16.
//  Copyright © 2016 Eric Klose. All rights reserved.
//

import UIKit
import Firebase

class HasherDataVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var nerdNameLbl: UILabel!
    @IBOutlet weak var hashNamesLbl: UILabel!
    @IBOutlet weak var kennelMembershipsLbl: UILabel!
    @IBOutlet weak var nerdNameTxtFld: UITextField!
    @IBOutlet weak var hashNamesTxtFld: UITextField!
    @IBOutlet weak var kennelMembershipsTxtFld: UITextField!
    @IBOutlet weak var updateInfoBtn: UIButton!
    @IBOutlet weak var nerdNamePencil: UIButton!
    @IBOutlet weak var kennelPickerView: UIPickerView!
    @IBOutlet weak var kennelPencil: UIButton!
    @IBOutlet weak var kennelListTableView: UITableView!
    
    var kennelPickerDataSource = [String]()
    var kennelChoice: String!
    var kennelChoiceId: String!
    var kennels = [KennelData]()
    var hasherDict: Dictionary<String, AnyObject>!
    var hasher: Hasher!
    var kennelAndNameDict: [String: String] = [:]
    var kennelAndHashNameDecodeDict: [String: String] = [:]
    var kennelMembershipIds = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.kennelPickerView.dataSource = self
        self.kennelPickerView.delegate = self
        
        self.kennelListTableView.dataSource = self
        self.kennelListTableView.delegate = self
        
        
    downloadHasherDetails { () -> () in
            self.updateHasherDisplay()
            
        }

    }
    
    
    func updateHasherDisplay() {
        self.nerdNameLbl.text = self.hasher.hasherNerdName
        
//        print("TEST5: \(kennelMembershipIds)")
//        print("KD: \(kennelAndNameDict)")
//        print("decode: \(kennelAndHashNameDecodeDict)")
        kennelListTableView.reloadData()
    }
    
    
    func downloadHasherDetails(completed: DownloadComplete) {
        DataService.ds.REF_HASHER_CURRENT.observeEventType(.Value, withBlock: { snapshot in
            //  print("snapshotY: \(snapshot)")
            
            if var hasherDict = snapshot.value as? Dictionary<String, AnyObject>{
                DataService.ds.REF_KENNELS.observeEventType(.Value, withBlock: { snapshot in
                    if let kennelDict = snapshot.value as? Dictionary<String, AnyObject> {
                        if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                            
                            for snap in snapshots {
                                
                                if let kennelDict2 = snap.value as? Dictionary<String, AnyObject> {
                                    let key = snap.key
                                    let name = kennelDict2["name"]!
                                    self.kennelAndNameDict[key] = (name as! String)
                                }
                            }
                        }
                    }
                    
                    hasherDict["addedKennelDict"] = self.kennelAndNameDict
               //     print("hasherDictNew: \(hasherDict)")
                    
                    self.hasher = Hasher(hasherInitId: KEY_UID, hasherInitDict: hasherDict)
                    print("1:\(self.hasher.hasherPrimaryHashName)")
                    
                    
                    
                    if let hashNamesAndKennels = hasherDict["hasherKennelsAndNames"] as? Dictionary<String, AnyObject> {
                        print("printme: \(hashNamesAndKennels)")
                        
                        for (key, value) in hashNamesAndKennels {
                            
                            if value as? String == "primary" {
                                
                                self.kennelAndHashNameDecodeDict[key] = self.hasher.hasherPrimaryHashName
                                
                            } else if value as! NSObject == true {
                                self.kennelAndHashNameDecodeDict[key] = ""
                                
                            }else {
                                self.kennelAndHashNameDecodeDict[key] = (value as! String)
                            }
                            
                        }
                        print("kennelAndNameDecodeDict: \(self.kennelAndHashNameDecodeDict)")
                        
                    }
                    self.kennelMembershipIds = [String](self.kennelAndHashNameDecodeDict.keys)
                    print("TEST: \(self.kennelMembershipIds)")
                    
                    
                    
                    
//                    self.createKennelsAndNamesDisplay(hasherDict, kennelAndHashNameDecodeDict: self.kennelAndHashNameDecodeDict)
                    completed()
                })
            }
       
        })

    }
    
// TRY SENDING CONFIGURE CELL BOTH THE NEW DICTIONARY AND KENNEL DICT TO INCLUDE KENNELID
//    func createKennelsAndNamesDisplay (hasherDict: Dictionary<String, AnyObject>, var kennelAndHashNameDecodeDict: Dictionary<String, String>) {
//
//            if let hashNamesAndKennels = hasherDict["hasherKennelsAndNames"] as? Dictionary<String, AnyObject> {
//                print("printme: \(hashNamesAndKennels)")
//
//                for (key, value) in hashNamesAndKennels {
//
//                    if value as? String == "primary" {
//
//                        kennelAndHashNameDecodeDict[key] = hasher.hasherPrimaryHashName
//                        
//                    } else if value as! NSObject == true {
//                        kennelAndHashNameDecodeDict[key] = ""
//                        
//                    }else {
//                        kennelAndHashNameDecodeDict[key] = (value as! String)
//                    }
//                    
//                }
//                print("kennelAndNameDecodeDict: \(kennelAndHashNameDecodeDict)")
//                
//            }
//        kennelMembershipIds = [String](kennelAndHashNameDecodeDict.keys)
//        print("TEST: \(kennelMembershipIds)")
//
//    }
    
    
    
    //
    //        DataService.ds.REF_KENNELS.observeEventType(.Value, withBlock: { snapshot in
    //
    //            if let kennelSnapshots = snapshot.children.allObjects as? [FDataSnapshot] {
    //
    //                for snapshot in kennelSnapshots {
    //
    //                    if let kennelNames = snapshot.value as? Dictionary<String, AnyObject> {
    //                        let kennelName = kennelNames["name"]!
    //                        self.kennelPickerDataSource.append(kennelName as! String)
    //                    }
    //                }
    //            }
    //        })
    
    
    
    
    
    func addNewHashNameToFirebase(hashName: String!) {
        
        if hashName != "Add Hash Name" && hashName != "" {
            
            let addName = ["\(hashName)": "true"]
            let hasherPath = Firebase(url: "\(DataService.ds.REF_HASHER_CURRENT)/hasherHashNames")
            
            hasherPath.updateChildValues(addName)
        }
        
    }
    
    func addNewKennelMembershipToFirebase(kennelName: String!) {
        
        if kennelName != "Add Kennel" && kennelName != "" {
            
            let addKennel = ["\(kennelName)": "true"]
            let kennelPath = Firebase(url: "\(DataService.ds.REF_HASHER_CURRENT)/hasherKennelMemberships")
            kennelPath.updateChildValues(addKennel)
        }
        
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
    
    @IBAction func editKennelPressed(sender: AnyObject) {
        kennelPickerView.reloadAllComponents()
        kennelPickerView.hidden = false
        kennelPencil.hidden = true
        updateInfoBtn.hidden = false
        
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return kennelPickerDataSource.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return kennelPickerDataSource[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.kennelChoice = kennelPickerDataSource[row]
        //print(kennelChoice)
    }
    
    func addNewKennel (kennelChoice: String) {
        
        DataService.ds.REF_KENNELS.observeEventType(.Value, withBlock: { snapshot in
            
            if let kennelSnapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                
                for snapshot in kennelSnapshots {
                    if let kennelNames = snapshot.value as? Dictionary<String, AnyObject> {
                        let kennelName = kennelNames["name"]!
                        if kennelName as! String == kennelChoice {
                            self.kennelChoiceId = snapshot.key
                        }
                    }
                }
            }
        })
        
        DataService.ds.REF_HASHER_CURRENT.observeEventType(.Value, withBlock: { snapshot in
            
            if let hasherDict = snapshot.value as? Dictionary<String, AnyObject> {
                if let kennelDict = hasherDict["hasherKennelMemberships"] as? Dictionary<String, AnyObject> {
                    if (kennelDict[self.kennelChoiceId] != nil) {
                        // checking to make sure hasher isn't already a member of given kennel
                        
                    } else {
                        let addKennel = ["\(self.kennelChoiceId)": "true"]
                        let kennelPath = Firebase(url: "\(DataService.ds.REF_HASHER_CURRENT)/hasherKennelMemberships")
                        kennelPath.updateChildValues(addKennel)
                    }
                    self.kennelPickerView.hidden = true
                    self.kennelPencil.hidden = false
                }
            }
        })
        
    }
    
    
    
    @IBAction func updateInfoPressed(sender: AnyObject) {
        //        addNewHashNameToFirebase(hashNamesTxtFld.text)
        //        addNewKennelMembershipToFirebase(kennelMembershipsTxtFld.text)
        editNerdNameInFirebase(nerdNameTxtFld.text)
        
        if self.kennelChoice == nil {
            kennelChoice = kennelPickerDataSource[0]
        }
        
        addNewKennel(kennelChoice)
        
        nerdNameTxtFld.hidden = true
        //        hashNamesTxtFld.hidden = true
        //        kennelMembershipsTxtFld.hidden = true
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
//        print("TESTTWOkennelandhashnamedecodedict: \(kennelAndHashNameDecodeDict)")
//        print("TESTkennelandnamedict: \(kennelAndNameDict)")
        let kennelMembershipId = kennelMembershipIds[indexPath.row]
        if let cell = tableView.dequeueReusableCellWithIdentifier("hasherCell") as? HasherCell {
            cell.configureCell(kennelMembershipId, kennelAndHashNameDecodeDict: kennelAndHashNameDecodeDict, kennelAndNameDict: kennelAndNameDict)
            return cell
        } else {
            return HasherCell()
        }
        
    }
    
    
}

