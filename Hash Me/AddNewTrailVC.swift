//
//  addNewTrailVC.swift
//  Hash Me
//
//  Created by Eric Klose on 3/14/16.
//  Copyright © 2016 Eric Klose. All rights reserved.
//

import UIKit


class AddNewTrailVC: UIViewController {
    
    @IBOutlet weak var newTrailDate: UILabel!
    @IBOutlet weak var newTrailKennelName: UITextField!
    @IBOutlet weak var newTrailTitle: UITextField!
    @IBOutlet weak var newTrailHares: UITextField!
    @IBOutlet weak var newTrailStartLocation: UITextField!
    @IBOutlet weak var newTrailHashCash: UITextField!
    @IBOutlet weak var newTrailDescription: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    var newTrailKennelId: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newTrailDate.text = ""
        newTrailKennelName.text = ""
        newTrailTitle.text = ""
        newTrailHares.text = ""
        newTrailStartLocation.text = ""
        newTrailHashCash.text = ""
        newTrailDescription.text = ""
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onPressedSaveButton(sender: AnyObject) {
        if (newTrailKennelName.text == "" || newTrailDate.text == "" || newTrailDate.text == "Date Required" || newTrailTitle.text == "") {
            
            self.newTrailDate.text = "Date Required"
            self.newTrailDate.backgroundColor = UIColor.redColor()
            
            self.newTrailTitle.text = "Title Required"
            self.newTrailTitle.backgroundColor = UIColor.redColor()
            
            self.newTrailKennelName.text = "Kennel Required"
            self.newTrailKennelName.backgroundColor = UIColor.redColor()
            
        } else {
        
        postTrailToFirebase()
    }
        
    }
    
    func postTrailToFirebase() {
            
            var trail: Dictionary<String, AnyObject> = [
                "trailDate": newTrailDate.text!,
                "trailKennelName": newTrailKennelName.text!,
                "trailKennelId": newTrailKennelId,
                "trailTitle": newTrailTitle.text!,
                "trailHares": newTrailHares.text!,
                "trailStartLocation": newTrailStartLocation.text!,
                "trailDescription": newTrailDescription.text!
            ]
            
            if newTrailHashCash.text == "" {
                trail["trailHashCash"] = 0
            } else {
                trail["trailHashCash"] = Int(newTrailHashCash.text!)
            }
            
            let firebasePost = DataService.ds.REF_TRAILS.childByAutoId()
            firebasePost.setValue(trail)
            
            newTrailDate.text = ""
            newTrailKennelName.text = ""
            newTrailTitle.text = ""
            newTrailHares.text = ""
            newTrailStartLocation.text = ""
            newTrailHashCash.text = ""
            newTrailDescription.text = ""
            newTrailKennelId = ""
            
            self.navigationController?.popViewControllerAnimated(true)
            
        }
    
    
    @IBAction func trailDatePicker(sender: UIButton) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM/dd/YY HH:mm"
        newTrailDate.text = dateFormatter.stringFromDate(datePicker.date)
    }
    
    @IBAction func getKennelFromKennelPickerVC(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? KennelPickerVC {
            if sourceViewController.kennelChoiceId == nil {
                newTrailKennelName.text = ""
                newTrailKennelId = nil
            } else {
                newTrailKennelName.text = sourceViewController.kennelChoiceName
                newTrailKennelId = sourceViewController.kennelChoiceId
            }
        }
    }
    
    //THIS SHOULD BE FINE SOON
//    @IBAction func getHasherFromHasherPickerVC(sender: UIStoryboardSegue) {
//        if let sourceViewController = sender.sourceViewController as? HasherPickerTableVC {
//            if sourceViewController.hasherChoiceId == nil {
//                specificAttendeeVirginSponsorIs.text = ""
//                trailAttendencePath.childByAppendingPath("trailAttendeeVirginSponsorIs").removeValue()
//                trailsAttendedPath.childByAppendingPath("hasherVirginSponsor").removeValue()
//                DataService.ds.REF_HASHERS.childByAppendingPath(specificAttendee.hasherId).childByAppendingPath("hasherOriginalSponsor").removeValue()
//            } else {
//                specificAttendeeVirginSponsorIs.text = sourceViewController.hasherChoiceName
//                trailAttendencePath.updateChildValues(["trailAttendeeVirginSponsorIs" : sourceViewController.hasherChoiceId])
//                trailsAttendedPath.updateChildValues(["hasherVirginSponsor" : sourceViewController.hasherChoiceId])
//                DataService.ds.REF_HASHERS.childByAppendingPath(specificAttendee.hasherId).updateChildValues(["hasherOriginalSponsor" : sourceViewController.hasherChoiceId])
//            }
//        }
//    }
    
}
