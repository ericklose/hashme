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
                let nerdNameLbl = hasherDict["hasherNerdNames"]!
                self.nerdNameLbl.text = "\(nerdNameLbl)"
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
        
        
    }
    
    
    
}

