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
        let story1 = Story(title: "#UHNApology", deck: "UHN apologizes for Toronto General vent grate that's 'hostile' to the homeless", body: "The University Health Network (UHN) apologized Wednesday for installing a grate over a vent outside of the Toronto General Hospital's Emergency Department specifically to deter homeless people from sleeping there, and says it will be removed.\n\nChan said the grate was installed because the area sees significant traffic from cars, ambulances and people. \n\nThere were also safety concerns with garbage and needles. UHN spokesperson Gill Howard told CBC's Metro Morning last Thursday that many Toronto General Emergency staff have already tried to help the homeless in front of the hospital.", date: "April 2, 2018", image: "yonge-and-elm-streets-shooting-bar", latitude: 43.6590522, longitude: -79.3901497, icon: Icon.Location, type: Type.Story, url: nil)
        stories.append(story1)
        
        let story2 = Story(title: "#GrilledCheese", deck: "Hundreds line up in cold for oversold grilled cheese festival", body: "An inaugural Toronto food festival left many waiting outside in the cold instead of enjoying some much-needed comfort food after the event was oversold by hundreds of tickets. \n\nClose to two dozen local vendors served up soup and sandwiches at the Grilled Cheese Fest Friday night at Roy Thomson Hall.\n\nOrganizer Melissa Chien said the event however was oversold by roughly 700 tickets leaving many outside the venue waiting to get in as temperatures dipped to - 15 C with the windchill.  The capacity for the event is 1500 people.\n\nThose locked out of the event took to Twitter to voice their frustration after paying $39.99 plus HST for the promise of all-you-can-eat grilled cheese, gourmet soups, and three beer samples.", date: "Today", image: "yonge-and-elm-streets-shooting-bar", latitude: 43.6469311, longitude: -79.3885312, icon: Icon.Breaking, type: Type.Story, url: nil)
        stories.append(story2)
        
        let story3 = Story(title: "#CondoFire", deck: "Southbound lanes of Spadina Avenue at Queen Street West closed", body: "Toronto firefighters managed to put out a fire on an upper floor of a condominium building near a major downtown intersection on Tuesday night.\n\nFirefighters said the 2-alarm fire at The Morgan building, a former warehouse converted into condominiums, was reported around 6:30 p.m. Thick black smoke and some flames could be seen pouring from one condo unit on the sixth floor.\n\nToronto Fire officials said the fire was knocked down in about 10 minutes. Nobody was injured.\n\nSome residents moved to the roof amid the blaze, firefighters said.\n\nIts unclear what caused the fire at this time.\n\nPolice have closed the southbound lanes of Spadina Avenue at Queen Street West.", date: "Today", image: "yonge-and-elm-streets-shooting-bar", latitude: 43.6478056, longitude: -79.4046328, icon: Icon.Breaking, type: Type.Story, url: nil)
        stories.append(story3)
        
        let story4 = Story(title: "#KingStPilot", deck: "Video of drivers ignoring King Street pilot has critic questioning police enforcement", body: "A taxi, then a black sedan, park in a TTC streetcar stop at King Street West and Peter Street.\n\nA growling Maserati leads a stream of cars going straight through that intersection, while at least two more vehicles make illegal left turns.\n\nNearly every motorist in the one-minute-and-nine-second video is breaking the rules of the King Street pilot project, the city's high-profile attempt to improve streetcar service in the downtown core.\n\nNot one driver, not even the driver filmed breaking the law right in front of a police cruiser, appears to get a ticket.", date: "April 2, 2018", image: "yonge-and-elm-streets-shooting-bar", latitude: 43.6460226, longitude: -79.4010278, icon: Icon.Location, type: Type.Story, url: nil)
        stories.append(story4)
        
        let story5 = Story(title: "#HomeOpener", deck: "Yankees beat Blue Jays 6-1 in Toronto's home opener", body: "The New York Yankees beat the Blue Jays 6-1 in the Toronto team's home opener at the Rogers Centre on Thursday.\n\nThe team honoured late pitcher Roy Halladay during a pre-game tribute at the Roger's Centre. Halladay's wife, Brandy, and sons, Braden and Ryan, stood on the infield as the his number, 32, was hoisted into the rafters. Halladay is the second Blue Jay in franchise history to have his number retired, alongside Roberto Alomar. There were two very noticeable absentees at the game this afternoon, one on the field and the other up in the broadcast booth.\n\nFor the first time since 2009, the Blue Jays will open a season without Jose Bautista as a member of the team.", date: "March 29, 2018", image: "yonge-and-elm-streets-shooting-bar", latitude: 43.6429557, longitude: -79.3905708, icon: Icon.Sports, type: Type.ARPhoto, url: "http://1.151.236.12/ar360/")
        stories.append(story5)
        
        let story6 = Story(title: "#Concert", deck: "The Crooked - Live at the Steam Whistle Brewing", body: "story", date: "February 15, 2018", image: "yonge-and-elm-streets-shooting-bar", latitude: 43.6417188, longitude: -79.3854774, icon: Icon.Sports, type: Type.ARVideo, url: "http://1.151.236.12/ar360/")
        stories.append(story6)
        
        let story7 = Story(title: "#InnovationSprint", deck: "27 pitches in 2 weeks: This is how we innovate", body: "story", date: "February 15, 2018", image: "yonge-and-elm-streets-shooting-bar", latitude: 43.6417188, longitude: -79.3854774, icon: Icon.Location, type: Type.ARPhoto, url: nil)
        stories.append(story7)

        
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
        
        let marker = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: nil)
        marker.displayPriority = .required
        marker.markerTintColor = #colorLiteral(red: 0.9019607843, green: 0.02352941176, blue: 0.01960784314, alpha: 1)

        
        if let pointAnnotation = annotation as? MKPointAnnotation {
            
            if pointAnnotation == self.userAnnotation {
                marker.glyphImage = UIImage(named: "user")
                return marker
            }
        }
        
        if annotation is StoryNode {
            marker.glyphImage = #imageLiteral(resourceName: "i_location")
            return marker
        }
        
        if annotation is ARMediaNode {
            marker.glyphImage = #imageLiteral(resourceName: "i_360")
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
                        self.mapView.region.span = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
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
