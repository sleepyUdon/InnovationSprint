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
    @IBOutlet weak var bottomView: BottomView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var ARButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    var userAnnotation: MKPointAnnotation?
    var locationEstimateAnnotation: MKPointAnnotation?
    var centerMapOnUserLocation: Bool = true
    var adjustNorthByTappingSidesOfScreen = false
    var viewMode = "2D"
    var bottomController: CTBottomSlideController?
    var updateUserLocationTimer: Timer?
    
    var stories: [Story] = []

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       self.viewMode = "2D"
        self.containerView.isUserInteractionEnabled = false
        
        // Set up views
        setupBottomView()
        setupButton(button: self.mapButton)
        setupButton(button: self.ARButton)
        setupMapView()
        setupARView()
        setupStories()
        createLocationNodesForMapView()
        createLocationNodesForARView ()
        
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

    // Load Stories
    func setupStories(){
        let story1 = Story(title: "#healthInspection", deck: "deck", body: "story", date: "date", image: "yonge-and-elm-streets-shooting-bar", latitude: 43.713303, longitude: -79.394958, icon: Icon.General, type: Type.Story, url: nil)
        stories.append(story1)
        
        let story2 = Story(title: "#stabbing", deck: "deck", body: "story", date: "date", image: "yonge-and-elm-streets-shooting-bar", latitude: 43.6469222, longitude: -79.4186588, icon: Icon.General, type: Type.Story, url: nil)
        stories.append(story2)
        
        let story3 = Story(title: "#MTV", deck: "deck", body: "story", date: "date", image: "yonge-and-elm-streets-shooting-bar", latitude: 43.6373712, longitude: -79.427477, icon: Icon.General, type: Type.Story, url: nil)
        stories.append(story3)
        
        let story4 = Story(title: "#YayoiKusama", deck: "deck", body: "story", date: "date", image: "yonge-and-elm-streets-shooting-bar", latitude: 43.6454625, longitude: -79.386103, icon: Icon.General, type: Type.Story, url: nil)
        stories.append(story4)
        
        let story5 = Story(title: "#YayoiKusama", deck: "deck", body: "story", date: "date", image: "yonge-and-elm-streets-shooting-bar", latitude: 43.652397, longitude: -79.412082, icon: Icon.General, type: Type.ARPhoto, url: "http://1.151.236.12/ar360/")
        stories.append(story5)
    }
    
    // Create all the nodes for the map view
    func createLocationNodesForMapView(){
        for story in stories {
            let mapCLLocation = CLLocationCoordinate2D(latitude: story.latitude, longitude: story.longitude)
            
            switch story.type {
            case .Story:
                if let title = story.title {
                    let mapStoryNode = StoryNode(title: title, deck: story.deck, body: story.body, date: story.date, image: story.image, coordinate: mapCLLocation)
                    self.mapView.addAnnotation(mapStoryNode)
                }
                
                
            case .ARVideo, .ARPhoto:
                if let title = story.title, let url = story.url {
                    let mapStoryNode = ARMediaNode(title: title, url: url, type: story.type, coordinate: mapCLLocation)
                    self.mapView.addAnnotation(mapStoryNode)
                } else {
                    //TODO: prompt error message
                }
            }
        }
    }
    
    // Create all the nodes for the AR View
    func createLocationNodesForARView(){
        for story in stories {
            let ARCLLocation = CLLocation(coordinate: CLLocationCoordinate2D(latitude: story.latitude, longitude: story.longitude), altitude: story.altitude)
            let pinMapLocationNode = LocationAnnotationNode(location: ARCLLocation, image: story.icon.image)
            let textNode = StoryAnnotationNode(location: ARCLLocation, title: story.title!, deck: story.deck, date: story.date
            , body: story.body, image: story.image)
            sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: pinMapLocationNode)
            sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: textNode)
        }
    }
    
    
    // General UI setup
    func setupBottomView() {
        bottomController = CTBottomSlideController(parent: view, bottomView: bottomView, tabController: nil, navController: nil, visibleHeight: 0)
        bottomController?.delegate = self
        bottomController?.setAnchorPoint(anchor: 0.8)
        bottomController?.setExpandedTopMargin(pixels: 620)
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
            self.mapButton.isHidden = true
            self.ARButton.isHidden = false
            mapView.alpha = 1
            sceneLocationView.alpha = 0
        } else {
            mapView.alpha = 0
            self.mapButton.isHidden = false
            self.ARButton.isHidden = true
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
        self.mapButton.isHidden = true
        self.ARButton.isHidden = false
        self.viewMode = "2D"
        mapView.alpha = 1
        sceneLocationView.alpha = 0
    }
    
    @IBAction func handleARButton(_ sender: UIButton) {
        self.mapButton.isHidden = false
        self.ARButton.isHidden = true
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
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotationNode = view.annotation as? StoryNode {
            self.bottomView.image.image = UIImage(named: annotationNode.image!)
            self.bottomView.title.text = annotationNode.title
            self.bottomView.deck.text = annotationNode.deck
            self.bottomView.body.text = annotationNode.body
            self.bottomController?.expandPanel()
        } else if let annotationNode = view.annotation as? ARMediaNode {
            let storyboard = UIStoryboard(name: "ARViewController", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "ARViewController")
            self.present(controller, animated: true, completion: nil)
        }
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
        
        // expand storyview
        
        let touch = touches.first
        var initialTouchLocation = CGPoint()
        initialTouchLocation = (touch?.location(in: sceneLocationView))!
        
        var hitTestOptions = [SCNHitTestOption: Any]()
        let results: [SCNHitTestResult] = sceneLocationView.hitTest(initialTouchLocation, options: hitTestOptions)
        for result in results {
            print(result)
            //            if VirtualObject.isNodePartOfVirtualObject(result.node) {
            //                firstTouchWasOnObject = true
            //                break
            print("something touched")
            
            if let parentNode = result.node.parent as? StoryAnnotationNode {
                self.bottomView.image.image = UIImage(named: parentNode.image)
                self.bottomView.title.text = parentNode.title
                self.bottomView.deck.text = parentNode.deck
                self.bottomView.body.text = parentNode.body
                self.bottomController?.expandPanel()
            }
        }
    }

//        if let touch = touches.first {
//            if touch.view != nil {
//                if (mapView == touch.view! ||
//                    mapView.recursiveSubviews().contains(touch.view!)) {
//                    centerMapOnUserLocation = false
//                } else {
//
//                    let location = touch.location(in: self.view)
//
//                    if location.x <= 40 && adjustNorthByTappingSidesOfScreen {
//                        print("left side of the screen")
//                        sceneLocationView.moveSceneHeadingAntiClockwise()
//                    } else if location.x >= view.frame.size.width - 40 && adjustNorthByTappingSidesOfScreen {
//                        print("right side of the screen")
//                        sceneLocationView.moveSceneHeadingClockwise()
//                    } else {
//                        let image = UIImage(named: "pin")!
//                        let annotationNode = LocationAnnotationNode(location: nil, image: image)
//                        annotationNode.scaleRelativeToDistance = true
//                        sceneLocationView.addLocationNodeForCurrentPosition(locationNode: annotationNode)
//                    }
//                }
//            }
//        }
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
        self.mapView.alpha = 1
        self.mapView.isUserInteractionEnabled = true
        self.containerView.isUserInteractionEnabled = false
    }
    
    func didPanelExpand(){
        self.mapView.alpha = 0.3
        self.mapView.isUserInteractionEnabled = false
        self.containerView.isUserInteractionEnabled = true
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
