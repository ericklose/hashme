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
    @IBOutlet weak var kennelUsState: UITextField!
    @IBOutlet weak var kennelCity: UITextField!
    @IBOutlet weak var kennelPostalCode: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var kennelMapView: MKMapView!
    
    var kennel: KennelData!
    
    let regionRadius: CLLocationDistance = 50000
    let locationManager = CLLocationManager()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        kennelMapView.delegate = self
        scrollView.delegate = self
        
        kennelName.text = kennel.kennelName
        kennelGeneralSchedule.text = kennel.kennelSchedule
        kennelCountry.text = kennel.kennelCountry
        kennelUsState.text = kennel.kennelState
        kennelCity.text = kennel.kennelCity
        kennelPostalCode.text = kennel.kennelPostalCode
        kennelDescription.text = kennel.kennelDescription
        
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2, regionRadius * 2)
        kennelMapView.setRegion(coordinateRegion, animated: true)
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation.isKindOfClass(BootcampAnnotation) {
            let annoView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Default")
            annoView.pinTintColor = UIColor.redColor()
            annoView.animatesDrop = true
            return annoView
        } else if annotation.isKindOfClass(MKUserLocation) {
            return nil
        }
        return nil
    }
    
    func createAnnotationForLocation(location: CLLocation) {
        let bootcamp = BootcampAnnotation(coordinate: location.coordinate)
        kennelMapView.addAnnotation(bootcamp)
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
        if kennelUsState.text != kennel.kennelState {
            kennel.kennelSetUsState(kennel.kennelId, newKennelUsState: kennelUsState.text!)
        }
        if kennelCountry.text != kennel.kennelCountry {
            kennel.kennelSetCountry(kennel.kennelId, newKennelCountry: kennelCountry.text!)
        }
        if kennelCity.text != kennel.kennelCity {
            kennel.kennelSetCity(kennel.kennelId, newKennelCity: kennelCity.text!)
        }
        if kennelPostalCode.text != kennel.kennelPostalCode {
            kennel.kennelSetPostalCode(kennel.kennelId, newKennelPostalCode: kennelPostalCode.text!)
        }
        navigationController?.popViewControllerAnimated(true)
    }
    
}
