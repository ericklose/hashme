//
//  MapAddressVC.swift
//  Hash Me
//
//  Created by Eric Klose on 4/22/16.
//  Copyright © 2016 Eric Klose. All rights reserved.
//

import MapKit
import UIKit
import FirebaseDatabase

class MapAddressVC: UIViewController, MKMapViewDelegate {
   
   
   @IBOutlet weak var kennelMapView: MKMapView!
   
    var kennels = [KennelData]()
   
   let regionRadius: CLLocationDistance = 1000
   
   let locationManager = CLLocationManager()
   
   //Lets pretend we downloaded these from the server
   //let aKennelAddress = DataService.ds.REF_KENNELS.child("-KFzXnkjval69MZ5K1k9")
   //let addresses = aKennelAddress as [String]
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      kennelMapView.delegate = self
      
      
      DataService.ds.REF_KENNELS.observeEventType(.Value, withBlock: { snapshot in
         
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
         for add in self.kennels {
            print("kennels ", self.kennels)
            self.getPlacemarkFromAddress(add.kennelLocation)
            print("address: ", add.kennelLocation)
         }

      })

   }
   
   override func viewDidAppear(animated: Bool) {
      locationAuthStatus()
   }
   
   func locationAuthStatus() {
      if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
         kennelMapView.showsUserLocation = true
      } else {
         locationManager.requestWhenInUseAuthorization()
      }
   }
   
   func centerMapOnLocation(location: CLLocation) {
      let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2, regionRadius * 2)
      kennelMapView.setRegion(coordinateRegion, animated: true)
   }
   
   func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
      
      if let loc = userLocation.location {
         centerMapOnLocation(loc)
      }
   }
   
   func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
      
      if annotation.isKindOfClass(KennelMapAnno) {
         let annoView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Default")
         annoView.pinTintColor = UIColor.blackColor()
         annoView.animatesDrop = true
         return annoView
      } else if annotation.isKindOfClass(MKUserLocation) {
         return nil
      }
      return nil
   }
   
   func createAnnotationForLocation(location: CLLocation) {
      let kennelMap = KennelMapAnno(coordinate: location.coordinate)
      kennelMapView.addAnnotation(kennelMap)
   }
   
   func getPlacemarkFromAddress(address: String) {
      CLGeocoder().geocodeAddressString(address) { (placemarks: [CLPlacemark]?, error: NSError?) -> Void in
         if let marks = placemarks where marks.count > 0 {
            if let loc = marks[0].location {
               //We have a valid location with coordinates
               self.createAnnotationForLocation(loc)
            }
         }
      }
   }
   
}
