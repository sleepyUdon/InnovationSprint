//
//  ViewController.swift
//  CBC AR360
//
//  Created by Viviane Chan on 2018-04-04.
//  Copyright © 2018 CBC. All rights reserved.
//

import UIKit
import MapKit
import SceneKit
import CTSlidingUpPanel


@available(iOS 11.0, *)
class ViewController: UIViewController, MKMapViewDelegate {

    // Set up properties
    @IBOutlet weak var sceneLocationView: SceneLocationView!
    @IBOutlet var bottomView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var ARButton: UIButton!
    
    var userAnnotation: MKPointAnnotation?
    var locationEstimateAnnotation: MKPointAnnotation?
    var centerMapOnUserLocation: Bool = true
    var adjustNorthByTappingSidesOfScreen = false
    var viewMode = "2D"
    var bottomController: CTBottomSlideController?
    var updateUserLocationTimer: Timer?

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       self.viewMode = "2D"
        
        // Set up views
        setupBottomView()
        setupButton(button: self.mapButton)
        setupButton(button: self.ARButton)
        setupMapView()
        setupARView()
        
//        let pinCoordinate = CLLocationCoordinate2D(latitude: 43.64655, longitude: -79.4445287)
//        let pinLocation = CLLocation(coordinate: pinCoordinate, altitude: 236)
//        let pinImage = UIImage(named: "pin")!
//        let pinLocationNode = LocationAnnotationNode(location: pinLocation, image: pinImage)
//        sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: pinLocationNode)
//        
        let pinCoordinate2 = CLLocationCoordinate2D(latitude: 43.6469222, longitude: -79.4186588)
        let pinLocation2 = CLLocation(coordinate: pinCoordinate2, altitude: 50)
        let pinText2 = "#Apartments"
        let pinLocationNode2 = StoryAnnotationNode(location: pinLocation2, text: pinText2, deck: "Couple has baby to get back at noisy neighbour", image: "Apartments", date: "15 May 2017")
        sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: pinLocationNode2)
        
        let pinCoordinate3 = CLLocationCoordinate2D(latitude: 43.713303, longitude: -79.394958)
        let pinLocation3 = CLLocation(coordinate: pinCoordinate3, altitude: 50)
        let pinText3 = "#Craiglist"
        let pinLocationNode3 = StoryAnnotationNode(location: pinLocation3, text: pinText3, deck: "Man gravely misunderstands Craigslist ad offering 'one nightstand'", image: "Craiglist", date: "15 April 2017")
        sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: pinLocationNode3)
        
        let pinCoordinate4 = CLLocationCoordinate2D(latitude: 43.6373712, longitude: 79.427477)
        let pinLocation4 = CLLocation(coordinate: pinCoordinate4, altitude: 50)
        let pinText4 = "#InstagramKid"
        let pinLocationNode4 = StoryAnnotationNode(location: pinLocation4, text: pinText4, deck: "Child sues parents for posting 'embarrassing' baby pictures on social media", image: "instagram-kid", date: "1 March 2017")
        sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: pinLocationNode4)
        
        let pinCoordinate5 = CLLocationCoordinate2D(latitude: 43.6454625, longitude: -79.386103)
        let pinLocation5 = CLLocation(coordinate: pinCoordinate5, altitude: 250)
        let pinText5 = "#SharingIsCaring"
        let pinLocationNode5 = StoryAnnotationNode(location: pinLocation5, text: pinText5, deck: "Man tries in vain to explain his nachos not for whole table",image: "nacho-sharing", date: "1 January 2017")
        sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: pinLocationNode5)

        
        updateUserLocationTimer = Timer.scheduledTimer(
            timeInterval: 0.5,
            target: self,
            selector: #selector(ViewController.updateUserLocation),
            userInfo: nil,
            repeats: true)
    }

    
    
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showViewControllers()
        sceneLocationView.run()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneLocationView.pause()
    }

    
    // General setup

    func setupBottomView() {
        bottomController = CTBottomSlideController(parent: view, bottomView: bottomView, tabController: self.tabBarController, navController: self.navigationController, visibleHeight: 134)
        bottomController?.setAnchorPoint(anchor: 0.7)
        bottomView.layer.shadowColor = UIColor.gray.cgColor
        bottomView.layer.shadowOffset = CGSize(width: 0, height: -3)
        bottomView.layer.shadowOpacity = 0.2
        bottomView.layer.shadowRadius = 5
        bottomView.layer.masksToBounds = false
    }
    
    func setupButton(button: UIButton) {
        button.layer.shadowColor = UIColor.darkGray.cgColor
        button.layer.shadowOffset = CGSize(width: 2, height: 3)
        button.layer.shadowOpacity = 0.4
        button.layer.shadowRadius = 6
        button.layer.masksToBounds = false
    }

    
    func showViewControllers() {
        if viewMode == "2D" {
            mapView.alpha = 1
            sceneLocationView.alpha = 0
        } else {
            mapView.alpha = 0
            sceneLocationView.alpha = 1
        }
    }
    
    
    func setupMapView() {
        mapView.delegate = self
        mapView.showsUserLocation = true
    }
    
    
    func setupARView() {
        sceneLocationView.locationDelegate = self
    }
    
    
    // Buttons Actions

    @IBAction func handleMapButon(_ sender: UIButton) {
        self.viewMode = "2D"
        mapView.alpha = 1
        sceneLocationView.alpha = 0
    }
    
    @IBAction func handleARButton(_ sender: UIButton) {
        self.viewMode = "3D"
        mapView.alpha = 0
        sceneLocationView.alpha = 1
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
    
    @objc func updateUserLocation() {
        if let currentLocation = sceneLocationView.currentLocation() {
            DispatchQueue.main.async {
                
                if let bestEstimate = self.sceneLocationView.bestLocationEstimate(),
                    let position = self.sceneLocationView.currentScenePosition() {
                }
                
                if self.userAnnotation == nil {
                    self.userAnnotation = MKPointAnnotation()
                    self.mapView.addAnnotation(self.userAnnotation!)
                }
                
                UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
                    self.userAnnotation?.coordinate = currentLocation.coordinate
                }, completion: nil)
                
                if self.centerMapOnUserLocation {
                    UIView.animate(withDuration: 0.45, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
                        self.mapView.setCenter(self.userAnnotation!.coordinate, animated: false)
                    }, completion: {
                        _ in
                        self.mapView.region.span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
                    })
                }
                
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if let touch = touches.first {
            if touch.view != nil {
                if (mapView == touch.view! ||
                    mapView.recursiveSubviews().contains(touch.view!)) {
                    centerMapOnUserLocation = false
                } else {
                    
                    let location = touch.location(in: self.view)
                    
                    if location.x <= 40 && adjustNorthByTappingSidesOfScreen {
                        print("left side of the screen")
                        sceneLocationView.moveSceneHeadingAntiClockwise()
                    } else if location.x >= view.frame.size.width - 40 && adjustNorthByTappingSidesOfScreen {
                        print("right side of the screen")
                        sceneLocationView.moveSceneHeadingClockwise()
                    } else {
                        let image = UIImage(named: "pin")!
                        let annotationNode = LocationAnnotationNode(location: nil, image: image)
                        annotationNode.scaleRelativeToDistance = true
                        sceneLocationView.addLocationNodeForCurrentPosition(locationNode: annotationNode)
                    }
                }
            }
        }
    }
    
    
    
}



//MARK: SceneLocationViewDelegate
extension ViewController: SceneLocationViewDelegate {
    
    func sceneLocationViewDidAddSceneLocationEstimate(sceneLocationView: SceneLocationView, position: SCNVector3, location: CLLocation) {
    }
    
    func sceneLocationViewDidRemoveSceneLocationEstimate(sceneLocationView: SceneLocationView, position: SCNVector3, location: CLLocation) {
    }
    
    func sceneLocationViewDidConfirmLocationOfNode(sceneLocationView: SceneLocationView, node: LocationNode) {
    }
    
    func sceneLocationViewDidSetupSceneNode(sceneLocationView: SceneLocationView, sceneNode: SCNNode) {
        
    }
    
    func sceneLocationViewDidUpdateLocationAndScaleOfLocationNode(sceneLocationView: SceneLocationView, locationNode: LocationNode) {
    }
}


extension ViewController: CTBottomSlideDelegate {
    
    func didPanelCollapse(){
        
    }
    
    func didPanelExpand(){
        
    }
    
    func didPanelAnchor(){
        
    }
    
    func didPanelMove(panelOffset: CGFloat){
        
    }
}

extension DispatchQueue {
    func asyncAfter(timeInterval: TimeInterval, execute: @escaping () -> Void) {
        self.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(timeInterval * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: execute)
    }
}


extension UIView {
    func recursiveSubviews() -> [UIView] {
        var recursiveSubviews = self.subviews
        
        for subview in subviews {
            recursiveSubviews.append(contentsOf: subview.recursiveSubviews())
        }
        
        return recursiveSubviews
    }
}
