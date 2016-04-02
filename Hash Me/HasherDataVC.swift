//
//  SecondViewController.swift (changed to HasherDataVC)
//  Hash Me
//
//  Created by Eric Klose on 3/12/16.
//  Copyright © 2016 Eric Klose. All rights reserved.
//

import UIKit
import Firebase

class HasherDataVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var nerdNameLbl: UILabel!
    @IBOutlet weak var hashNamesLbl: UILabel!
    @IBOutlet weak var kennelMembershipsLbl: UILabel!
    //    @IBOutlet weak var addInfoBtn: UIButton!
    @IBOutlet weak var nerdNameTxtFld: UITextField!
    @IBOutlet weak var hashNamesTxtFld: UITextField!
    @IBOutlet weak var kennelMembershipsTxtFld: UITextField!
    @IBOutlet weak var updateInfoBtn: UIButton!
    @IBOutlet weak var nerdNamePencil: UIButton!
    @IBOutlet weak var kennelPickerView: UIPickerView!
    @IBOutlet weak var kennelPencil: UIButton!
    
    var kennelPickerDataSource = [String]()
    var kennelChoice: String!
    var kennelChoiceId: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.kennelPickerView.dataSource = self
        self.kennelPickerView.delegate = self
        
        DataService.ds.REF_HASHER_CURRENT.observeEventType(.Value, withBlock: { snapshot in
            
            if let hasherDict = snapshot.value as? Dictionary<String, AnyObject> {
                let nerdNameLbl = hasherDict["hasherNerdName"]!
                self.nerdNameLbl.text = "\(nerdNameLbl)"
                self.nerdNameTxtFld.text = "\(nerdNameLbl)"
                
                if let hashNames = hasherDict["hasherHashNames"] as? Dictionary<String, String> {
                    
                    self.hashNamesLbl.text = ""
                    
                    let primaryHashName = hashNames.allKeysForValue("Primary")
                    let primary = primaryHashName[0]
                    self.hashNamesLbl.text = primary
                    
                    if hashNames.count > 1 {
                        let altHashNames = [String](hashNames.keys)
                        
                        for var x = 0; x < altHashNames.count; x += 1 {
                            let altName = altHashNames[x]
                            if altName != primary {
                                self.hashNamesLbl.text! += ", \(altName)"
                            }
                            
                        }
                        
                    }
                    
                }
                
                if let kennelNames = hasherDict["hasherKennelMemberships"] as? Dictionary<String, String> {
                    self.kennelMembershipsLbl.text = ""
                    
                    let primaryKennelName = kennelNames.allKeysForValue("Primary")
                    let primaryK = primaryKennelName[0]
                    
                    //call kennel data to change kennelid into actual name
                    DataService.ds.REF_KENNELS.observeEventType(.Value, withBlock: { snapshot in
                        
                        if let kennelDict = snapshot.value as? Dictionary<String, AnyObject> {
                            
                            if let kennelDict2 = kennelDict[primaryK] as? Dictionary<String, AnyObject> {
                                let primaryKName = kennelDict2["name"]!
                                self.kennelMembershipsLbl.text = primaryKName as! String
                            }
                            
                        }
                        
                    })
                    
                    
                    
                    if kennelNames.count > 1 {
                        let altKennelNames = [String](kennelNames.keys)
                        
                        for var x = 0; x < altKennelNames.count; x++ {
                            let altKennel = altKennelNames[x]
                            if altKennel != primaryK {
                                
                                DataService.ds.REF_KENNELS.observeEventType(.Value, withBlock: { snapshot in
                                    
                                    if let kennelDict = snapshot.value as? Dictionary<String, AnyObject> {
                                        if let kennelDict2 = kennelDict[altKennel] as? Dictionary<String, AnyObject> {
                                            let altKName = kennelDict2["name"]!
                                            self.kennelMembershipsLbl.text! += ", \(altKName)"
                                        }
                                        
                                    }
                                })
                            }
                            
                        }
                        
                    }
                }
                
                
            }
        })
        
        DataService.ds.REF_KENNELS.observeEventType(.Value, withBlock: { snapshot in
            
            if let kennelSnapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                
                for snapshot in kennelSnapshots {
                    
                    if let kennelNames = snapshot.value as? Dictionary<String, AnyObject> {
                        let kennelName = kennelNames["name"]!
                        self.kennelPickerDataSource.append(kennelName as! String)
                    }
                    
                }
            }
            
            
        })
        
    }
    
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
        print(kennelChoice)
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
    
    
    
    
    
    
    //    @IBAction func editInfoPressed(sender: AnyObject) {
    //        nerdNameTxtFld.hidden = false
    //        hashNamesTxtFld.hidden = false
    //        kennelMembershipsTxtFld.hidden = false
    //        updateInfoBtn.hidden = false
    //        addInfoBtn.hidden = true
    //    }
    
    @IBAction func updateInfoPressed(sender: AnyObject) {
        addNewHashNameToFirebase(hashNamesTxtFld.text)
        addNewKennelMembershipToFirebase(kennelMembershipsTxtFld.text)
        editNerdNameInFirebase(nerdNameTxtFld.text)
        
        if self.kennelChoice == nil {
            kennelChoice = kennelPickerDataSource[0]
        }
        
        addNewKennel(kennelChoice)
        
        nerdNameTxtFld.hidden = true
        hashNamesTxtFld.hidden = true
        kennelMembershipsTxtFld.hidden = true
        updateInfoBtn.hidden = true
        nerdNamePencil.hidden = false
        nerdNameLbl.hidden = false
    }
    
}

