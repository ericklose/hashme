//
//  MapAddressVC.swift
//  Hash Me
//
//  Created by Eric Klose on 4/22/16.
//  Copyright © 2016 Eric Klose. All rights reserved.
//

import MapKit
import UIKit

class MapAddressVC: UIViewController {

    
    @IBOutlet weak var TabMapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hasher.getLocation()
        
        let location = CLLocation()
        
    }


}
