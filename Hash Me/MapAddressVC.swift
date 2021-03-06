//
//  MapAddressVC.swift
//  Hash Me
//
//  Created by Eric Klose on 4/22/16.
//  Copyright © 2016 Eric Klose. All rights reserved.
//

import MapKit
import UIKit
import Firebase

class MapAddressVC: UIViewController, MKMapViewDelegate {
   
   
   @IBOutlet weak var kennelMapView: MKMapView!
   
   var kennels = [KennelData]()
   let regionRadius: CLLocationDistance = 1000
   let locationManager = CLLocationManager()
   
   override func viewDidLoad() {
      super.viewDidLoad()
      kennelMapView.delegate = self
      
      
      DataService.ds.REF_KENNELS.observe(.value, with: { snapshot in
         
         self.kennels = []
         if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
            for snap in snapshots {
               if let kennelDict = snap.value as? Dictionary<String, AnyObject> {
                  let key = snap.key
                  let kennelName = kennelDict["kennelName"] as? String
                  let kennel = KennelData(kennelInitId: key, kennelInitDict: kennelDict, kennelInitName: kennelName!)
                           print("loc: ", kennel.kennelLocation)
                  self.kennels.append(kennel)
               }
            }
         }
         for address in self.kennels {
//            self.getPlacemarkFromAddress(address.kennelLocation)
            print("address: ", address.kennelLocation)
         }
      })
   }
   
   override func viewDidAppear(_ animated: Bool) {
      locationAuthStatus()
   }
   
   func locationAuthStatus() {
      if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
         kennelMapView.showsUserLocation = true
      } else {
         locationManager.requestWhenInUseAuthorization()
      }
   }
   
   func centerMapOnLocation(_ location: CLLocation) {
      let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2, regionRadius * 2)
      kennelMapView.setRegion(coordinateRegion, animated: true)
   }
   
   func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
      
      if let loc = userLocation.location {
         centerMapOnLocation(loc)
      }
   }
   
   func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
      
      if annotation.isKind(of: KennelMapAnno.self) {
         let annoView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Default")
         annoView.pinTintColor = UIColor.black
         annoView.animatesDrop = true
         return annoView
      } else if annotation.isKind(of: MKUserLocation.self) {
         return nil
      }
      return nil
   }
   
   func createAnnotationForLocation(_ location: CLLocation) {
      let kennelMap = KennelMapAnno(coordinate: location.coordinate)
      kennelMapView.addAnnotation(kennelMap)
   }
   
//   func getPlacemarkFromAddress(_ address: String) {
//      CLGeocoder().geocodeAddressString(address) { (placemarks: [CLPlacemark]?, error: NSError?) -> Void in
//         if let marks = placemarks , marks.count > 0 {
//            if let loc = marks[0].location {
//               //We have a valid location with coordinates
//               self.createAnnotationForLocation(loc)
//            }
//         }
//      } as! CLGeocodeCompletionHandler
//   }
   
}
