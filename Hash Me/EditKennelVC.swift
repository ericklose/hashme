//
//  EditKennelVC.swift
//  Hash Me
//
//  Created by Eric Klose on 4/23/16.
//  Copyright © 2016 Eric Klose. All rights reserved.
//

import UIKit

class EditKennelVC: UIViewController {
    
    @IBOutlet weak var kennelName: UITextField!
    @IBOutlet weak var kennelGeneralSchedule: UITextField!
    @IBOutlet weak var kennelCountry: UITextField!
    @IBOutlet weak var kennelUsState: UITextField!
    
    var kennel: KennelData!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        kennelName.text = kennel.kennelName
        kennelGeneralSchedule.text = kennel.kennelSchedule
        kennelCountry.text = kennel.kennelCountry
        kennelUsState.text = kennel.kennelUsState
        
    }
    

    @IBAction func kennelSaveBtnPressed(sender: UIButton) {
        
        if kennelName.text != kennel.kennelName && kennelName.text != "" {
            kennel.kennelSetName(kennel.kennelId, newKennelName: kennelName.text!)
        }
        
        if kennelGeneralSchedule.text != kennel.kennelSchedule {
            kennel.kennelSetSchedule(kennel.kennelId, newKennelSchedule: kennelGeneralSchedule.text!)
        }
        
        if kennelUsState.text != kennel.kennelUsState {
            kennel.kennelSetUsState(kennel.kennelId, newKennelUsState: kennelUsState.text!)
        }
        
        if kennelCountry.text != kennel.kennelCountry {
            kennel.kennelSetCountry(kennel.kennelId, newKennelCountry: kennelCountry.text!)
        }
        navigationController?.popViewControllerAnimated(true)
    }

}
