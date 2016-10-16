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
    @IBOutlet weak var editAnotherHasherBtn: UIButton!
    @IBOutlet weak var returnToMyDataBtn: UIButton!
    
    var hasherDict: Dictionary<String, AnyObject>!
    var hasher: Hasher!
    var kennelAndNameDict: [String: String] = [:]
    var kennelAndHashNameDecodeDict: [String: String] = [:]
    var kennelMembershipIds = [String]()
    var kennelMembershipId = String!.self
    var hasherKennelIdsAndNamesDict: [String: String] = [:]
    var hasherPrimaryKennel: String!
    var meOrSelectedHasherId: String!
    var newHasherIsSelected: Bool! = false
    var hasherChoiceId: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() 
        
        self.kennelListTableView.dataSource = self
        self.kennelListTableView.delegate = self
        
        
//        downloadHasherDetails { () -> () in
//            self.updateHasherDisplay()
//    }

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
    
    override func viewDidAppear(_ animated: Bool) {
        if newHasherIsSelected == true {
            meOrSelectedHasherId = hasherChoiceId //sent from hasher picker VC
            returnToMyDataBtn.isHidden = false
        } else {
            meOrSelectedHasherId = DataService.ds.REF_HASHER_USERID
        }
        
        downloadHasherDetails { () -> () in
            self.updateHasherDisplay()
    }
}
    
    func downloadHasherDetails(_ completed: @escaping DownloadComplete) {
        
        DataService.ds.REF_HASHERS.child(meOrSelectedHasherId).observe(.value, with: { snapshot in
            
            self.kennelMembershipIds = []
            self.kennelAndHashNameDecodeDict = [:]
            self.kennelAndNameDict = [:]
            
            if var hasherDict = snapshot.value as? Dictionary<String, AnyObject>{
                DataService.ds.REF_KENNELS.observe(.value, with: { snapshot in
                    if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                        for snap in snapshots {
                            if let kennelDict2 = snap.value as? Dictionary<String, AnyObject> {
                                let key = snap.key
                                let name = kennelDict2["kennelName"]!
                                self.kennelAndNameDict[key] = (name as! String)
                            }
                        }
                    }
                    hasherDict["addedKennelDict"] = self.kennelAndNameDict as AnyObject?
                    self.hasher = Hasher(hasherInitId: self.meOrSelectedHasherId, hasherInitDict: hasherDict)
                    self.kennelAndHashNameDecodeDict = [:]
                    if let hashNamesAndKennels = hasherDict["hasherKennelsAndNames"] as? Dictionary<String, AnyObject> {
                        for (key, value) in hashNamesAndKennels {
                            if value as? String == "primary" {
                                //take primary kennel and hashname out of table
                                
                            } else if value as! Bool == true {
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
    
    @IBAction func returnToMyDataBtnPressed(_ sender: AnyObject) {
        returnToMyDataBtn.isHidden = true
        newHasherIsSelected = false
        viewDidAppear(true)
    }
    
    
    @IBAction func editNerdNamePressed(_ sender: AnyObject) {
        nerdNameTxtFld.isHidden = false
        nerdNameLbl.isHidden = true
        nerdNamePencil.isHidden = true
        updateInfoBtn.isHidden = false
    }
    
    @IBAction func updateInfoPressed(_ sender: AnyObject) {
        hasher.editNerdNameInFirebase(hasher.hasherId, nerdName: nerdNameTxtFld.text!)
        hasher.editPrimaryHashNameInFirebase(hasher.hasherId, primaryName: primaryHashNameTxtFld.text)
        
        nerdNameTxtFld.isHidden = true
        updateInfoBtn.isHidden = true
        nerdNamePencil.isHidden = false
        nerdNameLbl.isHidden = false
        primaryHashNameTxtFld.isHidden = true
        primaryHashNameLbl.isHidden = false
        primaryHashNamePencil.isHidden = false
        
        updateInfoBtn.isHidden = true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kennelMembershipIds.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let kennelMembershipId = kennelMembershipIds[(indexPath as NSIndexPath).row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "hasherCell") as? HasherCell {
            cell.configureCell(hasher.hasherId, kennelMembershipId: kennelMembershipId, kennelAndHashNameDecodeDict: kennelAndHashNameDecodeDict, kennelAndNameDict: kennelAndNameDict)
            return cell
        } else {
            return HasherCell()
        }
        
    }
    //TABLE to add new kennels
    @IBAction func getKennelFromKennelPickerVC(_ sender: UIStoryboardSegue) {
        
        if let sourceViewController = sender.source as? KennelPickerTableVC {
            let hasherKennelsArray = kennelAndHashNameDecodeDict.keys
//            let hasherTrailsAndNamesUrl = DataService.ds.REF_HASHERS.child(hasher.hasherId).child("hasherKennelsAndNames")
            
            if sourceViewController.kennelChoiceId != nil && !hasherKennelsArray.contains(sourceViewController.kennelChoiceId) {
                hasher.editHasherKennelMembership(hasher.hasherId, kennelId: sourceViewController.kennelChoiceId)
                
//                hasherTrailsAndNamesUrl.updateChildValues([sourceViewController.kennelChoiceId! : true])
//                let kennelMembersUrl = DataService.ds.REF_KENNELS.child(sourceViewController.kennelChoiceId).child("kennelMembers")
//                kennelMembersUrl.updateChildValues([hasher.hasherId: true])
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pickHasherPrimaryKennel" {
            if let KennelPickerVC = segue.destination as? KennelPickerVC {
                
                let hasherKennelsArray = kennelAndHashNameDecodeDict.keys
                for key in hasherKennelsArray {
                    self.hasherKennelIdsAndNamesDict[kennelAndNameDict[key]!] = key
                }
                KennelPickerVC.hasherKennelIdsAndNamesDict = hasherKennelIdsAndNamesDict
            }
        }
    }
    
    //PICKER to select/change primary kennel
//    @IBAction func getKennelFromOriginalKennelPicker(_ sender: UIStoryboardSegue) {
//        
//        if let sourceViewController = sender.source as? KennelPickerVC {
//            let primaryKennelUrl = DataService.ds.REF_HASHERS.child(hasher.hasherId)
//            let hasherKennelsAndNamesUrl = DataService.ds.REF_HASHERS.child(hasher.hasherId).child("hasherKennelsAndNames")
//            
//            if sourceViewController.kennelChoiceId != nil {
//                if hasherPrimaryKennel != nil {
//                    hasherKennelsAndNamesUrl.updateChildValues([hasherPrimaryKennel as String: true])
//                    primaryKennelUrl.updateChildValues(["hasherPrimaryKennel" : sourceViewController.kennelChoiceId!])
//                } else {
//                    primaryKennelUrl.updateChildValues(["hasherPrimaryKennel" : sourceViewController.kennelChoiceId!])
//                }
//                hasherKennelsAndNamesUrl.updateChildValues([sourceViewController.kennelChoiceId : "primary"])
//            }
//        }
//    }
    
    @IBAction func editPrimaryHashNamePressed(_ sender: AnyObject) {
        primaryHashNameTxtFld.isHidden = false
        primaryHashNameLbl.isHidden = true
        primaryHashNamePencil.isHidden = true
        updateInfoBtn.isHidden = false
    }
    
    @IBAction func getHasherFromHasherPicker(_ sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? HasherPickerVC {
            if sourceViewController.hasherChoiceId != nil {
               self.hasherChoiceId = sourceViewController.hasherChoiceId
                newHasherIsSelected = true
            }
        }
    }
    
}
