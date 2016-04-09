//
//  ManageKennelVC.swift
//  Hash Me
//
//  Created by Eric Klose on 4/9/16.
//  Copyright © 2016 Eric Klose. All rights reserved.
//

import UIKit
import Firebase

class ManageKennelVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var kennelDetailsTableView: UITableView!
    
    @IBOutlet weak var kennelNameLbl: UILabel!
    @IBOutlet weak var kennelNameEditLbl: UIButton!
    @IBOutlet weak var kennelNameEditField: UITextField!
    @IBOutlet weak var kennelNameSaveLbl: UIButton!
    @IBOutlet weak var kennelScheduleLbl: UILabel!
    @IBOutlet weak var kennelScheduleEditLbl: UIButton!
    @IBOutlet weak var kennelScheduleEditField: UITextField!
    @IBOutlet weak var kennelScheduleSaveLbl: UIButton!
    @IBOutlet weak var kennelCountryLbl: UILabel!
    @IBOutlet weak var kennelCountryEditLbl: UIButton!
    @IBOutlet weak var kennelCountryEditField: UITextField!
    @IBOutlet weak var kennelCountrySaveLbl: UIButton!
    @IBOutlet weak var kennelUsStateLbl: UILabel!
    @IBOutlet weak var kennelUsStateEditLbl: UIButton!
    @IBOutlet weak var kennelUsStateEditField: UITextField!
    @IBOutlet weak var kennelUsStateSaveLbl: UIButton!
    
    var kennels: KennelData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        kennelDetailsTableView.delegate = self
        kennelDetailsTableView.dataSource = self
        
    }
    
    override func viewDidAppear(animated: Bool) {
        kennelNameEditField.hidden = true
        kennelNameSaveLbl.hidden = true
        kennelScheduleEditField.hidden = true
        kennelScheduleSaveLbl.hidden = true
        kennelCountryEditField.hidden = true
        kennelCountrySaveLbl.hidden = true
        kennelUsStateEditField.hidden = true
        kennelUsStateSaveLbl.hidden = true
    
        updateKennelDetails()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("kennelDetailsCell") as? KennelCell {
            
            //cell.configureCell(kennels)
            return cell
        } else {
            return AttendeeCell()
        }
    }
    
    func updateKennelDetails() {
        kennelNameLbl.text = kennels.kennelName
        kennelNameEditField.text = kennels.kennelName
        kennelScheduleLbl.text = kennels.kennelSchedule
        kennelScheduleEditField.text = kennels.kennelSchedule
        kennelCountryLbl.text = kennels.kennelCountry
        kennelCountryEditField.text = kennels.kennelCountry
        kennelUsStateLbl.text = kennels.kennelUsState
        kennelUsStateEditField.text = kennels.kennelUsState
    }
    
    @IBAction func editKennelName(sender: UIButton) {
        kennelNameEditField.hidden = false
        kennelNameSaveLbl.hidden = false
        kennelNameLbl.hidden = true
        kennelNameEditLbl.hidden = true
    }
    
    @IBAction func editKennelSchedule(sender: UIButton) {
        kennelScheduleLbl.hidden = true
        kennelScheduleEditLbl.hidden = true
        kennelScheduleEditField.hidden = false
        kennelScheduleSaveLbl.hidden = false
    }
    
    @IBAction func editKennelCountry(sender: UIButton) {
        kennelCountryLbl.hidden = true
        kennelCountryEditLbl.hidden = true
        kennelCountryEditField.hidden = false
        kennelCountrySaveLbl.hidden = false
    }
    
    @IBAction func editKennelUsState(sender: UIButton) {
        kennelUsStateLbl.hidden = true
        kennelUsStateEditLbl.hidden = true
        kennelUsStateEditField.hidden = false
        kennelUsStateSaveLbl.hidden = false
    }
    
    @IBAction func saveKennelName(sender: UIButton) {
        kennelNameLbl.hidden = false
        kennelNameEditLbl.hidden = false
        kennelNameEditField.hidden = true
        kennelNameSaveLbl.hidden = true
        if kennelNameEditField.text == nil || kennelNameEditField == "" {
            return
        } else {
            postKennelToFirebase("name", saveValue: kennelNameEditField.text!)
        }
    }
    
    @IBAction func saveKennelSchedule(sender: UIButton) {
        kennelScheduleLbl.hidden = false
        kennelScheduleEditLbl.hidden = false
        kennelScheduleEditField.hidden = true
        kennelScheduleSaveLbl.hidden = true
    }
    
    @IBAction func saveKennelCountry(sender: UIButton) {
        kennelCountryLbl.hidden = false
        kennelCountryEditLbl.hidden = false
        kennelCountryEditField.hidden = true
        kennelCountrySaveLbl.hidden = true
    }
    
    @IBAction func saveKennelUsState(sender: UIButton) {
        kennelUsStateLbl.hidden = false
        kennelUsStateEditLbl.hidden = false
        kennelUsStateEditField.hidden = true
        kennelUsStateSaveLbl.hidden = true
    }
    
    
    func postKennelToFirebase(saveType: String, saveValue: String) {
        
        DataService.ds.REF_KENNELS.childByAppendingPath(kennels.kennelId).updateChildValues([saveType: saveValue])
        
    }
    
    
}
