//
//  BootcampAnnotation.swift
//  DevBootcamps
//
//  Created by Mark Price on 1/1/16.
//  Copyright © 2016 Mark Price. All rights reserved.
//

import Foundation
import MapKit

class BootcampAnnotation: NSObject, MKAnnotation {
    var coordinate = CLLocationCoordinate2D()
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}