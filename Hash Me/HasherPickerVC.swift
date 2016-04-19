//
//  HasherPickerVC.swift
//  Hash Me
//
//  Created by Eric Klose on 4/19/16.
//  Copyright © 2016 Eric Klose. All rights reserved.
//

import UIKit
import Firebase

class HasherPickerVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var hasherSelected: UILabel!
    @IBOutlet weak var hasherPicker: UIPickerView!
    @IBOutlet weak var saveHasherBtn: UIButton!
    @IBOutlet weak var addNewHasherBtn: UIButton!
    @IBOutlet weak var hasherSearchBar: UISearchBar!
    var inSearchMode = false
    
    var hasherPickerNames = ["-Select Hasher-"]
    var hasherPickerDict: Dictionary<String, String>!
    var hasherChoiceName: String!
    var hasherChoiceId: String!
    var hasherDecoderDict: [String: String] = [:]
    var filteredHasherPickerNames = ["-Select Hasher-"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hasherPicker.delegate = self
        hasherPicker.dataSource = self
        hasherSearchBar.delegate = self
        hasherSearchBar.returnKeyType = UIReturnKeyType.Done
        
        addNewHasherBtn.enabled = false
        
        loadHasherData { () -> () in
            self.hasherPicker.reloadAllComponents()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadHasherData(completed: DownloadComplete) {
        DataService.ds.REF_HASHERS.observeEventType(.Value, withBlock: { snapshot in
            if let hasherDict = snapshot.value as? Dictionary<String, AnyObject> {
                
                if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                    self.hasherPickerNames = []
                    for snap in snapshots {
                        if let hasherDict2 = snap.value as? Dictionary<String, AnyObject> {
                            let hasherKey = snap.key
                            let hasherName = hasherDict2["hasherHashName"]!
                            
                            print("hasherpicker: \(self.hasherPickerNames)")
                            self.hasherPickerNames.append(hasherName as! String)
                            self.hasherDecoderDict[hasherName as! String] = (hasherKey)
                        }
                    }
                }
            }
            print("Final H Picker: \(self.hasherDecoderDict)")
            completed()
        })
        
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if inSearchMode {
            return filteredHasherPickerNames.count
        } else {
            return hasherPickerNames.count
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if inSearchMode {
            return filteredHasherPickerNames[row]
        } else {
            return hasherPickerNames[row]
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if inSearchMode {
            hasherSelected.text = filteredHasherPickerNames[row]
            self.hasherChoiceName = filteredHasherPickerNames[row]
        } else {
            hasherSelected.text = hasherPickerNames[row]
            self.hasherChoiceName = hasherPickerNames[row]
        }
    }
    
    func selectHasher(hasherChoice: String) {
        
        DataService.ds.REF_HASHERS.observeEventType(.Value, withBlock: { snapshot in
            
            if let hasherSnapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                
                for snapshot in hasherSnapshots {
                    if let hasherNames = snapshot.value as? Dictionary<String, AnyObject> {
                        let hasherName = hasherNames["hasherPrimaryHashName"]!
                        self.hasherChoiceId = self.hasherDecoderDict[hasherName as! String]
                    }
            }
            }
        })
    }

    @IBAction func saveHasherBtnPressed(sender: UIButton) {
        if self.hasherChoiceName != nil && self.hasherChoiceName != "-Select Hasher-" {
            hasherChoiceId = hasherDecoderDict[hasherChoiceName]!
        } else {
            hasherChoiceId = nil
        }
    }
    
    //UNWIND FROM ADD TRAIL & FROM ATTENDEE DETAILS
    //WILL QUICKLY NEED TO CHANGE UI OF ADD TRAIL TO ALLOW MULTIPLE HARES
    //OBVIOUSLY ALSO NEED TO CHANGE TRAIL DATA STRUCTURE & TRAIL SAVING
    

}
