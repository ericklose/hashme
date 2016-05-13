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
        self.hideKeyboardWhenTappedAround()
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
                
                if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                    self.hasherPickerNames = ["-Select Hasher-"]
                    for snap in snapshots {
                        if let hasherDict2 = snap.value as? Dictionary<String, AnyObject> {
                            let hasherKey = snap.key
                            let hasherName = hasherDict2["hasherPrimaryHashName"]!
                            self.hasherPickerNames.append(hasherName as! String)
                            self.hasherDecoderDict[hasherName as! String] = (hasherKey)
                        }
                    }
                }
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
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            view.endEditing(true)
            self.hasherPicker.reloadAllComponents()
        } else {
            inSearchMode = true
            let lower = searchBar.text!.lowercaseString
            filteredHasherPickerNames = hasherPickerNames.filter({$0.lowercaseString.rangeOfString(lower) != nil})
            self.hasherPicker.reloadAllComponents()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if self.hasherChoiceName != nil && self.hasherChoiceName != "-Select Hasher-" {
            hasherChoiceId = hasherDecoderDict[hasherChoiceName]!
        } else {
            hasherChoiceId = nil
        }
    }
    
    @IBAction func saveHasherBtnPressed(sender: UIButton) {
        if inSearchMode && self.hasherChoiceName == nil {
            self.hasherChoiceName = filteredHasherPickerNames[0]
            performSegueWithIdentifier("pickAnotherHasherToEdit", sender: sender)
        } else {
        performSegueWithIdentifier("pickAnotherHasherToEdit", sender: sender)
        }
           }

}
