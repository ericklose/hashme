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
    
 //   var hasher: Hasher!
    
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
<<<<<<< HEAD
                
=======
                    
>>>>>>> 9a25ef9afbca23db1db3d1f76f21eb88d20a69ff
                    if keyArray.count > 1 {
                        for var x = 1; x < keyArray.count; x++ {
                            let name = keyArray[x]
                                print(name)
                                self.hashNamesLbl.text! += ", \(name)"
<<<<<<< HEAD
=======
                            
>>>>>>> 9a25ef9afbca23db1db3d1f76f21eb88d20a69ff
                        }
                    }
                }
                
            //}
            
//            
//            // You should check to see if a value exists for `orch_array` first.
//            if let dict: AnyObject = NSUserDefaults().dictionaryForKey("orch_array")?[orchId] {
//                // Then force downcast.
//                let orch = dict as! [String: String]
//                orch[appleId] // No error
//            }
//            2. Use optional binding to check if orch is nil:
//            
//            if let orch = NSUserDefaults().dictionaryForKey("orch_array")?[orchId] as? [String: String] {
//                orch[appleId] // No error
//            }
//            
            
//            if let moves = dict["moves"] as? [Dictionary<String, AnyObject>]
//                where moves.count > 0 {
//                    if let name = moves[0]["name"] {
//                        self._move = name.capitalizedString
//                        
//                    }
//                    
//                    if moves.count > 1 {
//                        for var x = 1; x < moves.count; x++ {
//                            if let name = moves[x]["name"] {
//                                self._move! += ", \(name.capitalizedString)"
//                            }
//                        }
//                    }
//            } else {
//                self._move = ""
//            }

            
            
            
//            if let hasherDict2 = snapshot.value as? Dictionary<String, Array<String>> {
//                
//                
//            }
            
        })
       
        
        
        
        
//        DataService.ds.REF_POSTS.observeEventType(.Value, withBlock: { snapshot in
//            print(snapshot.value)
//            
//            self.posts = []
//            
//            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
//                
//                for snap in snapshots {
//                    print("SNAP: \(snap)")
//                    
//                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
//                        let key = snap.key
//                        let post = Post(postKey: key, dictionary: postDict)
//                        self.posts.append(post)
//                    }
//                }
//            }
//            
//            self.tableView.reloadData()
//        })

        
        
        
        
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

