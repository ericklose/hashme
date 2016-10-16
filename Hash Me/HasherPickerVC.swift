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
        hasherSearchBar.returnKeyType = UIReturnKeyType.done
        
        addNewHasherBtn.isEnabled = false
        
        loadHasherData { () -> () in
            self.hasherPicker.reloadAllComponents()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadHasherData(_ completed: @escaping DownloadComplete) {
        DataService.ds.REF_HASHERS.observe(.value, with: { snapshot in
                
                if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if inSearchMode {
            return filteredHasherPickerNames.count
        } else {
            return hasherPickerNames.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if inSearchMode {
            return filteredHasherPickerNames[row]
        } else {
            return hasherPickerNames[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if inSearchMode {
            hasherSelected.text = filteredHasherPickerNames[row]
            self.hasherChoiceName = filteredHasherPickerNames[row]
        } else {
            hasherSelected.text = hasherPickerNames[row]
            self.hasherChoiceName = hasherPickerNames[row]
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            view.endEditing(true)
            self.hasherPicker.reloadAllComponents()
        } else {
            inSearchMode = true
            let lower = searchBar.text!.lowercased()
            filteredHasherPickerNames = hasherPickerNames.filter({$0.lowercased().range(of: lower) != nil})
            self.hasherPicker.reloadAllComponents()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if self.hasherChoiceName != nil && self.hasherChoiceName != "-Select Hasher-" {
            hasherChoiceId = hasherDecoderDict[hasherChoiceName]!
        } else {
            hasherChoiceId = nil
        }
    }
    
    @IBAction func saveHasherBtnPressed(_ sender: UIButton) {
        if inSearchMode && self.hasherChoiceName == nil {
            self.hasherChoiceName = filteredHasherPickerNames[0]
            performSegue(withIdentifier: "pickAnotherHasherToEdit", sender: sender)
        } else {
        performSegue(withIdentifier: "pickAnotherHasherToEdit", sender: sender)
        }
           }

}
