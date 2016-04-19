//
//  HasherPickerVC.swift
//  Hash Me
//
//  Created by Eric Klose on 4/19/16.
//  Copyright © 2016 Eric Klose. All rights reserved.
//

import UIKit

class HasherPickerVC: UIViewController {

    @IBOutlet weak var hasherSelected: UILabel!
    @IBOutlet weak var hasherPicker: UIPickerView!
    @IBOutlet weak var saveHasherBtn: UIButton!
    @IBOutlet weak var addNewHasherBtn: UIButton!
    @IBOutlet weak var hasherSearchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNewHasherBtn.enabled = false
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    @IBAction func saveHasherBtnPressed(sender: UIButton) {
    }
    
    //UNWIND FROM ADD TRAIL & FROM ATTENDEE DETAILS
    //WILL QUICKLY NEED TO CHANGE UI OF ADD TRAIL TO ALLOW MULTIPLE HARES
    //OBVIOUSLY ALSO NEED TO CHANGE TRAIL DATA STRUCTURE & TRAIL SAVING
    

}
