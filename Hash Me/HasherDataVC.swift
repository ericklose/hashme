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
            print(snapshot.value)
            
            
            if let hasherDict = snapshot.value as? Dictionary<String, AnyObject> {
                let nerdNameLbl = hasherDict["hasherNerdName"]!
                self.nerdNameLbl.text = "\(nerdNameLbl)"
                self.nerdNameTxtFld.text = "\(nerdNameLbl)"
                print("nerd: \(nerdNameLbl)")
                
                let hashNames = hasherDict["hasherHashNames"] as? Dictionary<String, AnyObject>
                
                self.hashNamesLbl.text = ""
                
                let keyArray = [String](hashNames!.keys)
                print(keyArray[0])
                self.hashNamesLbl.text = keyArray[0]
                
                if keyArray.count > 1 {
                    for var x = 1; x < keyArray.count; x++ {
                        let name = keyArray[x]
                        print(name)
                        self.hashNamesLbl.text! += ", \(name)"
                        
                    }
                }
                
                let kennelMemberships = hasherDict["hasherKennelMemberships"] as? Dictionary<String, AnyObject>
                
                self.kennelMembershipsLbl.text = ""
                
                let kennelArray = [String](kennelMemberships!.keys)
                print(kennelArray[0])
                self.kennelMembershipsLbl.text = kennelArray[0]
                
                if kennelArray.count > 1 {
                    for var x = 1; x < kennelArray.count; x++ {
                        let kennel = kennelArray[x]
                        print(kennel)
                        self.kennelMembershipsLbl.text! += ", \(kennel)"
                        
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

