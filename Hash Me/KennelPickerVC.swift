//
//  KennelPickerVC.swift
//  Hash Me
//
//  Created by Eric Klose on 4/13/16.
//  Copyright © 2016 Eric Klose. All rights reserved.
//

import UIKit
import Firebase

class KennelPickerVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var kennelPicker: UIPickerView!
    @IBOutlet weak var kennelSelected: UILabel!
    @IBOutlet weak var kennelSavedBtn: UIButton!
    
    @IBOutlet weak var kennelSearchBar: UISearchBar!
    var inSearchMode: Bool = false
    
    var kennelPickerDict: Dictionary<String, String>!
    var kennelPickerNames = ["-Select Kennel-"]
    var filteredKennelPickerNames = ["-Select Kennel-"]
    var kennelChoiceName: String!
    var kennelChoiceId: String!
    var kennelDecoderDict: [String: String] = [:]
    var hasherKennelIdsAndNamesDict: Dictionary<String, String>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        kennelPicker.delegate = self
        kennelPicker.dataSource = self
        kennelSearchBar.delegate = self
        kennelSearchBar.returnKeyType = UIReturnKeyType.Done
        
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
                
                if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                    self.kennelPickerNames = ["-Select Kennel-"]
                    for snap in snapshots {
                        if let kennelDict2 = snap.value as? Dictionary<String, AnyObject> {
                            let kennelKey = snap.key
                            let kennelName = kennelDict2["kennelName"]!
                            self.kennelPickerNames.append(kennelName as! String)
                            self.kennelDecoderDict[kennelName as! String] = (kennelKey)
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
        if inSearchMode {
            return filteredKennelPickerNames.count
        } else {
            return kennelPickerNames.count
        }
    }
    
    func pickerView(kennelPicker: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if inSearchMode {
            return filteredKennelPickerNames[row]
        } else {
            return kennelPickerNames[row]
        }
    }
    
    func pickerView(kennelPicker: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if inSearchMode {
            kennelSelected.text = filteredKennelPickerNames[row]
            self.kennelChoiceName = filteredKennelPickerNames[row]
        } else {
            kennelSelected.text = kennelPickerNames[row]
            self.kennelChoiceName = kennelPickerNames[row]
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            view.endEditing(true)
            self.kennelPicker.reloadAllComponents()
        } else {
            inSearchMode = true
            let lower = searchBar.text!.lowercaseString
            filteredKennelPickerNames = kennelPickerNames.filter({$0.lowercaseString.rangeOfString(lower) != nil})
            self.kennelPicker.reloadAllComponents()
        }
    }
    
    @IBAction func kennelPickerSaved(sender: UIButton) {
        if self.kennelChoiceName != nil && self.kennelChoiceName != "-Select Kennel-" {
            kennelChoiceId = kennelDecoderDict[kennelChoiceName]!
        } else {
            kennelChoiceId = nil
        }
    }
}