//
//  KennelMapAnno.swift
//  Hash Me
//
//  Created by Eric Klose on 5/6/16.
//  Copyright © 2016 Eric Klose. All rights reserved.
//

import Foundation
import MapKit

class KennelMapAnno: NSObject, MKAnnotation {
    var coordinate = CLLocationCoordinate2D()
    

    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}