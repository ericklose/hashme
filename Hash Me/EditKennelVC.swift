//
//  EditKennelVC.swift
//  Hash Me
//
//  Created by Eric Klose on 4/23/16.
//  Copyright © 2016 Eric Klose. All rights reserved.
//

import UIKit
import MapKit

class EditKennelVC: UIViewController, MKMapViewDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var kennelName: UITextField!
    @IBOutlet weak var kennelDescription: UITextView!
    @IBOutlet weak var kennelGeneralSchedule: UITextField!
    @IBOutlet weak var kennelCountry: UITextField!
    @IBOutlet weak var kennelState: UITextField!
    @IBOutlet weak var kennelCity: UITextField!
    @IBOutlet weak var kennelPostalCode: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var kennelMapView: MKMapView!
    
    var kennel: KennelData!
    
    let regionRadius: CLLocationDistance = 50000
    let locationManager = CLLocationManager()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        kennelMapView.delegate = self
        scrollView.delegate = self
        kennelMapView.zoomEnabled = true
        kennelMapView.rotateEnabled = true
        kennelMapView.showsCompass = true
        kennelMapView.showsScale = true
        kennelMapView.showsUserLocation = true
        getPlacemarkFromAddress(kennel.kennelCityAndRegion)
        
        kennelName.text = kennel.kennelName
        kennelGeneralSchedule.text = kennel.kennelSchedule
        kennelCountry.text = kennel.kennelCountry
        kennelState.text = kennel.kennelState
        kennelCity.text = kennel.kennelCity
        kennelPostalCode.text = kennel.kennelPostalCode
        kennelDescription.text = kennel.kennelDescription
        
    }
    
    override func viewDidAppear(animated: Bool) {
        locationAuthStatus()
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2, regionRadius * 2)
        kennelMapView.setRegion(coordinateRegion, animated: true)
    }

// THIS IS NOT WORKING AT ALL BUT DOESN'T MATTER FOR THIS KENNEL USAGE
    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            kennelMapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }

// THIS IS TO CENTER MAP ON USER WHICH IS NOT APPROPRIATE FOR A KENNEL MAP BUT I WANT TO KEEP THE CODE
//    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
//        
//        if let loc = userLocation.location {
//            centerMapOnLocation(loc)
//        }
//    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation.isKindOfClass(KennelMapAnno) {
            let annoView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Default")
            annoView.pinTintColor = UIColor.redColor()
            annoView.animatesDrop = true
            return annoView
        } else if annotation.isKindOfClass(MKUserLocation) {
            return nil
        }
        return nil
    }
    
    func createAnnotationForLocation(location: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = kennel.kennelName
        annotation.subtitle = kennel.kennelCityAndRegion
        kennelMapView.addAnnotation(annotation)
    }
    
    func getPlacemarkFromAddress(address: String) {
        CLGeocoder().geocodeAddressString(address) { (placemarks: [CLPlacemark]?, error: NSError?) -> Void in
            if let marks = placemarks where marks.count > 0 {
                if let loc = marks[0].location {
                    self.createAnnotationForLocation(loc.coordinate)
                    self.centerMapOnLocation(loc)
                }
            }
        }
    }
    
    
    @IBAction func kennelSaveBtnPressed(sender: UIButton) {
        
        if kennelName.text != kennel.kennelName && kennelName.text != "" {
            kennel.kennelSetName(kennel.kennelId, newKennelName: kennelName.text!)
        }
        if kennelDescription.text != kennel.kennelDescription {
            kennel.kennelSetDescription(kennel.kennelId, newKennelDescription: kennelDescription.text!)
        }
        if kennelGeneralSchedule.text != kennel.kennelSchedule {
            kennel.kennelSetSchedule(kennel.kennelId, newKennelSchedule: kennelGeneralSchedule.text!)
        }
        if kennelCountry.text != kennel.kennelCountry {
            kennel.kennelSetCountry(kennel.kennelId, newKennelCountry: kennelCountry.text!)
        }
        if kennelState.text != kennel.kennelState {
            kennel.kennelSetState(kennel.kennelId, newKennelState: kennelState.text!)
        }
        if kennelCity.text != kennel.kennelCity {
            kennel.kennelSetCity(kennel.kennelId, newKennelCity: kennelCity.text!)
        }
        if kennelPostalCode.text != kennel.kennelPostalCode {
            kennel.kennelSetPostalCode(kennel.kennelId, newKennelPostalCode: kennelPostalCode.text!)
        }
        //let kennelMapLocationString: String = kennelCity.text + ", " + kennelState.text + ", " + kennelPostalCode.text + ", " + kennelCountry.text
        
        navigationController?.popViewControllerAnimated(true)
    }
    
}
