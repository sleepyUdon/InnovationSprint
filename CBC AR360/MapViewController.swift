//
//  MapViewController.swift
//  CBC AR360
//
//  Created by Viviane Chan on 2018-04-04.
//  Copyright © 2018 CBC. All rights reserved.
//

import UIKit
import MapKit
import SceneKit


class MapViewController: UIViewController, MKMapViewDelegate  {
    @IBOutlet weak var mapView: MKMapView!

    var userAnnotation: MKPointAnnotation?
    var locationEstimateAnnotation: MKPointAnnotation?
    var updateUserLocationTimer: Timer?
    var showMapView: Bool = true
    var centerMapOnUserLocation: Bool = true
    var adjustNorthByTappingSidesOfScreen = false


    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Currently set to CBC
        //TODO: get current location
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.alpha = 0.8
        view.addSubview(mapView)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    
    
    
    //MARK: MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        if let pointAnnotation = annotation as? MKPointAnnotation {
            let marker = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: nil)
            
            if pointAnnotation == self.userAnnotation {
                marker.displayPriority = .required
                marker.glyphImage = UIImage(named: "user")
            } else {
                marker.displayPriority = .required
                marker.markerTintColor = UIColor(hue: 0.267, saturation: 0.67, brightness: 0.77, alpha: 1.0)
                marker.glyphImage = UIImage(named: "compass")
            }
            
            return marker
        }
        
        return nil
    }



}
