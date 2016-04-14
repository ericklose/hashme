//
//  KennelPickerVC.swift
//  Hash Me
//
//  Created by Eric Klose on 4/13/16.
//  Copyright © 2016 Eric Klose. All rights reserved.
//

import UIKit
import Firebase

class KennelPickerVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var kennelPicker: UIPickerView!
    @IBOutlet weak var kennelSelected: UILabel!
    
    var kennelPickerDict: Dictionary<String, String>!
    var kennelPickerNames = [String]()
    var kennelChoiceName: String!
    var kennelChoiceId: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        kennelPicker.delegate = self
        kennelPicker.dataSource = self
        
        loadKennelData { () -> () in
            self.kennelPicker.reloadAllComponents()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadKennelData(completed: DownloadComplete) {
        DataService.ds.REF_KENNELS.observeEventType(.Value, withBlock: { snapshot in
            
            if let kennelSnapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                
                for snapshot in kennelSnapshots {
                    
                    if let kennelNames = snapshot.value as? Dictionary<String, AnyObject> {
                        let kennelName = kennelNames["name"]!
                        self.kennelPickerNames.append(kennelName as! String)
                    }
                }
            }
            completed()
        })
    }
    
    func numberOfComponentsInPickerView(kennelPicker: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(kennelPicker: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return kennelPickerNames.count
    }
    
    func pickerView(kennelPicker: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return kennelPickerNames[row]
    }
    
    func pickerView(kennelPicker: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        kennelSelected.text = kennelPickerNames[row]
        self.kennelChoiceName = kennelPickerNames[row]
        //print(kennelChoice)
    }
    
    
    @IBAction func kennelPickerSaved(sender: UIButton) {
        if self.kennelChoiceName == nil {
            kennelChoiceName = kennelPickerNames[0]
        }
        
        selectKennel(kennelChoiceName)
        
    }
    
    func selectKennel (kennelChoice: String) {
        
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
                }
            }
        })
        
    }
    

    
}
