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
        self.hideKeyboardWhenTappedAround() 
        
        newTrailDate.text = ""
        newTrailKennelName.text = ""
        newTrailTitle.text = ""
        newTrailHares.text = ""
        newTrailStartLocation.text = ""
        newTrailHashCash.text = ""
        newTrailDescription.text = ""
        
    }
    
    @IBAction func onPressedSaveButton(_ sender: AnyObject) {
        if (newTrailKennelName.text == "" || newTrailDate.text == "" || newTrailDate.text == "Date Required" || newTrailTitle.text == "") {
            
            self.newTrailDate.text = "Date Required"
            self.newTrailDate.backgroundColor = UIColor.red
            
            self.newTrailTitle.text = "Title Required"
            self.newTrailTitle.backgroundColor = UIColor.red
            
            self.newTrailKennelName.text = "Kennel Required"
            self.newTrailKennelName.backgroundColor = UIColor.red
            
        } else {
            
            postTrailToFirebase()
        }
        
    }
    
    func postTrailToFirebase() {
        
        var trail: Dictionary<String, AnyObject> = [
            "trailDate": newTrailDate.text! as AnyObject,
            "trailKennelName": newTrailKennelName.text! as AnyObject,
            "trailKennelId": newTrailKennelId as AnyObject,
            "trailTitle": newTrailTitle.text! as AnyObject,
            "trailHares": newTrailHares.text! as AnyObject,
            "trailStartLocation": newTrailStartLocation.text! as AnyObject,
            "trailDescription": newTrailDescription.text! as AnyObject
        ]
        
        if newTrailHashCash.text == "" {
            trail["trailHashCash"] = 0 as AnyObject?
        } else {
            trail["trailHashCash"] = Int(newTrailHashCash.text!) as AnyObject?
        }
        
        let firebasePost = DataService.ds.REF_TRAILS.childByAutoId()
        let trailRef = firebasePost.key
        firebasePost.setValue(trail)
        DataService.ds.REF_KENNELS.child(newTrailKennelId).child("kennelTrails").child(trailRef).setValue(trail)
        
        newTrailDate.text = ""
        newTrailKennelName.text = ""
        newTrailTitle.text = ""
        newTrailHares.text = ""
        newTrailStartLocation.text = ""
        newTrailHashCash.text = ""
        newTrailDescription.text = ""
        newTrailKennelId = ""
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func trailDatePicker(_ sender: UIButton) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/YY HH:mm"
        newTrailDate.text = dateFormatter.string(from: datePicker.date)
    }
    
    @IBAction func getKennelFromKennelPickerVC(_ sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? KennelPickerTableVC {
            if sourceViewController.kennelChoiceId == nil {
                newTrailKennelName.text = ""
                newTrailKennelId = nil
            } else {
                newTrailKennelName.text = sourceViewController.kennelChoiceName
                newTrailKennelId = sourceViewController.kennelChoiceId
            }
        }
    }
    
    
    //THIS IS FOR HARES
    //    @IBAction func getHasherFromHasherPickerVC(sender: UIStoryboardSegue) {
    //        if let sourceViewController = sender.sourceViewController as? HasherPickerTableVC {
    //            if sourceViewController.hasherChoiceId == nil {
    //                specificAttendeeVirginSponsorIs.text = ""
    //                trailAttendencePath.child("trailAttendeeVirginSponsorIs").removeValue()
    //                trailsAttendedPath.child("hasherVirginSponsor").removeValue()
    //                DataService.ds.REF_HASHERS.child(specificAttendee.hasherId).child("hasherOriginalSponsor").removeValue()
    //            } else {
    //                specificAttendeeVirginSponsorIs.text = sourceViewController.hasherChoiceName
    //                trailAttendencePath.updateChildValues(["trailAttendeeVirginSponsorIs" : sourceViewController.hasherChoiceId])
    //                trailsAttendedPath.updateChildValues(["hasherVirginSponsor" : sourceViewController.hasherChoiceId])
    //                DataService.ds.REF_HASHERS.child(specificAttendee.hasherId).updateChildValues(["hasherOriginalSponsor" : sourceViewController.hasherChoiceId])
    //            }
    //        }
    //    }
    
}
