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
    @IBOutlet weak var kennelSavedBtn: UIButton!
    
    var kennelPickerDict: Dictionary<String, String>!
    var kennelPickerNames = ["-Select Kennel-"]
    var kennelChoiceName: String!
    var kennelChoiceId: String!
    var kennelDecoderDict: [String: String] = [:]
    
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
                
                if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                    self.kennelPickerNames = ["-Select Kennel-"]
                    for snap in snapshots {
                        if let kennelDict2 = snap.value as? Dictionary<String, AnyObject> {
                            let kennelKey = snap.key
                            let kennelName = kennelDict2["name"]!
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
        return kennelPickerNames.count
    }
    
    func pickerView(kennelPicker: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return kennelPickerNames[row]
    }
    
    func pickerView(kennelPicker: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        kennelSelected.text = kennelPickerNames[row]
        self.kennelChoiceName = kennelPickerNames[row]
    }
    
    
    @IBAction func kennelPickerSaved(sender: UIButton) {
        if self.kennelChoiceName != nil && self.kennelChoiceName != "-Select Kennel-" {
            kennelChoiceId = kennelDecoderDict[kennelChoiceName]!
        } else {
            kennelChoiceId = nil
        }
    }
}