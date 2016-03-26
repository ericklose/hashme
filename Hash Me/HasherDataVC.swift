//
//  SecondViewController.swift (changed to HasherDataVC)
//  Hash Me
//
//  Created by Eric Klose on 3/12/16.
//  Copyright © 2016 Eric Klose. All rights reserved.
//

import UIKit
import Firebase

class HasherDataVC: UIViewController {
    
    @IBOutlet weak var nerdNameLbl: UILabel!
    @IBOutlet weak var hashNamesLbl: UILabel!
    @IBOutlet weak var kennelMembershipsLbl: UILabel!
    @IBOutlet weak var addInfoBtn: UIButton!
    @IBOutlet weak var nerdNameTxtFld: UITextField!
    @IBOutlet weak var hashNamesTxtFld: UITextField!
    @IBOutlet weak var kennelMembershipsTxtFld: UITextField!
    @IBOutlet weak var updateInfoBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataService.ds.REF_HASHER_CURRENT.observeEventType(.Value, withBlock: { snapshot in
            //print(snapshot.value)
            
            if let hasherDict = snapshot.value as? Dictionary<String, AnyObject> {
                print("Hasher Dict: \(hasherDict)")
                let nerdNameLbl = hasherDict["hasherNerdName"]!
                self.nerdNameLbl.text = "\(nerdNameLbl)"
                self.nerdNameTxtFld.text = "\(nerdNameLbl)"
                print("nerd: \(nerdNameLbl)")
                
                if let hashNames = hasherDict["hasherHashNames"] as? Dictionary<String, String> {
                    
                    self.hashNamesLbl.text = ""
                    
                    let primaryHashName = hashNames.allKeysForValue("Primary")
                    print("primary hash name: \(primaryHashName)")
                    let primary = primaryHashName[0]
                    self.hashNamesLbl.text = primary
                    
                    if hashNames.count > 1 {
                        let altHashNames = [String](hashNames.keys)
                        
                        for var x = 0; x < altHashNames.count; x += 1 {
                            let altName = altHashNames[x]
                            if altName != primary {
                                self.hashNamesLbl.text! += ", \(altName)"
                            }
                            
                            if let kennelNames = hasherDict["hasherKennelMemberships"] as? Dictionary<String, String> {
                                self.kennelMembershipsLbl.text = ""
                                
                                let primaryKennelName = kennelNames.allKeysForValue("Primary")
                                print("primary kennel name: \(primaryKennelName)")
                                let primaryK = primaryKennelName[0]
                                
                                //call kennel data to change kennelid into actual name
                                DataService.ds.REF_KENNELS.observeEventType(.Value, withBlock: { snapshot in
                                    print(snapshot.value)
                                    
                                    if let kennelDict = snapshot.value as? Dictionary<String, AnyObject> {
                                        if let kennelDict2 = kennelDict[primaryK] as? Dictionary<String, String> {
                                            let primaryKName = kennelDict2["name"]!
                                            print("kennelname: \(primaryKName)")
                                            self.kennelMembershipsLbl.text = primaryKName
                                        }
                                        
                                    }
                                    
                                })
                                
                                
                                
                                if kennelNames.count > 1 {
                                    let altKennelNames = [String](kennelNames.keys)
                                    print(altKennelNames)
                                    
                                    for var x = 0; x < altKennelNames.count; x++ {
                                        let altKennel = altKennelNames[x]
                                        if altKennel != primaryK {
                                            
                                            DataService.ds.REF_KENNELS.observeEventType(.Value, withBlock: { snapshot in
                                                print(snapshot.value)
                                                
                                                if let kennelDict = snapshot.value as? Dictionary<String, AnyObject> {
                                                    print("secondsnapshot: \(snapshot.value)")
                                                    print("altkennel: \(altKennel)")
                                                    if let kennelDict2 = kennelDict[altKennel] as? Dictionary<String, AnyObject> {
                                                        
                                                        let altKName = kennelDict2["name"]!
                                                        print("altkennelname: \(altKName)")
                                                        self.kennelMembershipsLbl.text! += ", \(altKName)"
                                                    }
                                                    
                                                }
                                            })
                                        }
                                        
                                    }
                                }
                            }
                            
                        }
                        
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
            print(snapshot.value)
            
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
    
    @IBAction func editInfoPressed(sender: AnyObject) {
        nerdNameTxtFld.hidden = false
        hashNamesTxtFld.hidden = false
        kennelMembershipsTxtFld.hidden = false
        updateInfoBtn.hidden = false
        addInfoBtn.hidden = true
    }
    
    @IBAction func updateInfoPressed(sender: AnyObject) {
        addNewHashNameToFirebase(hashNamesTxtFld.text)
        addNewKennelMembershipToFirebase(kennelMembershipsTxtFld.text)
        editNerdNameInFirebase(nerdNameTxtFld.text)
        
        nerdNameTxtFld.hidden = true
        hashNamesTxtFld.hidden = true
        kennelMembershipsTxtFld.hidden = true
        updateInfoBtn.hidden = true
        addInfoBtn.hidden = false
    }
    
}

