//
//  addNewTrailVC.swift
//  Hash Me
//
//  Created by Eric Klose on 3/14/16.
//  Copyright © 2016 Eric Klose. All rights reserved.
//

import UIKit

class AddNewTrailVC: UIViewController {
    
    @IBOutlet weak var newTrailDate: UITextField!
    @IBOutlet weak var newTrailKennel: UITextField!
    @IBOutlet weak var newTrailHares: UITextField!
    @IBOutlet weak var newTrailStartLocation: UITextField!
    @IBOutlet weak var newTrailHashCash: UITextField!
    @IBOutlet weak var newTrailDescription: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onPressedSaveButton(sender: AnyObject) {
        postTrailToFirebase()
    }

        func postTrailToFirebase() {
    
            let trail: Dictionary<String, AnyObject> = [
                "trailDate": newTrailDate.text!,
                "trailKennel": newTrailKennel.text!,
                "trailHares": newTrailHares.text!,
                "trailStartLocation": newTrailStartLocation.text!,
                "trailHashCash": newTrailHashCash.text!,
                "trailDescription": newTrailDescription.text!
                ]
            
            let firebasePost = DataService.ds.REF_TRAILS.childByAutoId()
            firebasePost.setValue(trail)
            
            newTrailDate.text = ""
            newTrailKennel.text = ""
            newTrailHares.text = ""
            newTrailStartLocation.text = ""
            newTrailHashCash.text = ""
            newTrailDescription.text = ""
            
            self.navigationController?.popViewControllerAnimated(true)
    
    }
}
