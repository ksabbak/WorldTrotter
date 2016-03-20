//
//  MapViewController.swift
//  WorldTrotter
//
//  Created by k_sabbak on 3/11/16.
//  Copyright © 2016 k_sabbak. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    var mapView: MKMapView!
    
    var initialMapView = true
    
    let locationManager = CLLocationManager()
    
    var locationArray = ["Paris", "Times Square", "Chicago", "self"]
    
    override func loadView()
    {
        mapView = MKMapView()
        
        //The view
        view = mapView
    
        let standardString = NSLocalizedString("Standard", comment: "Standard map view")
        let satelliteString = NSLocalizedString("Satellite", comment: "Satellite map view")
        let hybridString = NSLocalizedString("Hybrid", comment: "Hybrid map view")
        
        let segmentedControl = UISegmentedControl(items: [standardString, hybridString, satelliteString])
        
        segmentedControl.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        segmentedControl.selectedSegmentIndex = 0
        
        segmentedControl.addTarget(self, action: "mapTypeChanged:", forControlEvents: .ValueChanged)
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        
        let margins = view.layoutMarginsGuide
        
        let topConstraint = segmentedControl.topAnchor.constraintEqualToAnchor(topLayoutGuide.bottomAnchor, constant: 8)
        let leadingConstraint = segmentedControl.leadingAnchor.constraintEqualToAnchor(margins.leadingAnchor)
        let trailingConstraint = segmentedControl.trailingAnchor.constraintEqualToAnchor(margins.trailingAnchor)
        
        topConstraint.active = true
        leadingConstraint.active = true
        trailingConstraint.active = true
        
        let pinButton = UIButton()
        
        pinButton.setTitle("Go to Pin", forState: .Normal)
        pinButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        pinButton.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.4)
        pinButton.addTarget(self, action: "onPinButtonTapped:", forControlEvents: .TouchUpInside)
        
        view.addSubview(pinButton)
        
        pinButton.translatesAutoresizingMaskIntoConstraints = false
        
        let buttonTopConstraint = pinButton.topAnchor.constraintEqualToAnchor(segmentedControl.bottomAnchor, constant: 8)
        let buttonLeadingConstraint = pinButton.leadingAnchor.constraintEqualToAnchor(margins.leadingAnchor)
        let buttonTrailingConstraint = pinButton.trailingAnchor.constraintEqualToAnchor(margins.trailingAnchor)
        
        buttonLeadingConstraint.active = true
        buttonTopConstraint.active = true
        buttonTrailingConstraint.active = true
        
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        mapView.delegate = self
        mapView.showsUserLocation = true
       
        print("MapViewController loaded its view")
        dropPinForLocation("Paris")
        dropPinForLocation("Times Square")
        dropPinForLocation("Chicago")
        
    }
    
    func dropPinForLocation(address: String)
    {
        let geolocation = CLGeocoder()
        
        geolocation.geocodeAddressString(address) { (placemarks:[CLPlacemark]?, error:NSError?) -> Void in
            for placemark in placemarks!
            {
                let annotation = MKPointAnnotation()
                annotation.coordinate = (placemark.location?.coordinate)!
                annotation.title = address
                self.mapView.addAnnotation(annotation)
            }
            
        }
    }

    
    func mapTypeChanged(segControl: UISegmentedControl)
    {
        switch segControl.selectedSegmentIndex
        {
        case 0:
            mapView.mapType = .Standard
        case 1:
            mapView.mapType = .Hybrid
        case 2:
            mapView.mapType = .Satellite
        default:
            break
        }
    }
    
    func onPinButtonTapped(button: UIButton)
    {
        if locationArray[0] == "self"
        {
            self.mapView.setRegion(MKCoordinateRegionMake(mapView.userLocation.coordinate, MKCoordinateSpanMake(0.3, 0.3)), animated: true)
        }
        else
        {
            let geolocation = CLGeocoder()
            geolocation.geocodeAddressString(locationArray[0]) { (placemarks:[CLPlacemark]?, error:NSError?) -> Void in
                for placemark in placemarks!
                {
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = (placemark.location?.coordinate)!
                    self.mapView.setRegion(MKCoordinateRegionMake(annotation.coordinate, MKCoordinateSpanMake(0.3, 0.3)), animated: true)
                }
            }
        }
        
            locationArray.append(locationArray[0])
            locationArray.removeFirst()
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?
    {
        if annotation.isEqual(mapView.userLocation)
        {
            return nil
        }
        else
        {
            let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
            
            return pin

        }
    }
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation)
    {
        if initialMapView
        {
            self.mapView.setRegion(MKCoordinateRegionMake(userLocation.coordinate, MKCoordinateSpanMake(0.3, 0.3)), animated: true)
            initialMapView = false
        }
    }
    
}
