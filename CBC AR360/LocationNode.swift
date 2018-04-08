//
//  LocationNode.swift
//  ARKit+CoreLocation
//
//  Created by Andrew Hart on 02/07/2017.
//  Copyright © 2017 Project Dent. All rights reserved.
//

import Foundation
import SceneKit
import CoreLocation

///A location node can be added to a scene using a coordinate.
///Its scale and position should not be adjusted, as these are used for scene layout purposes
///To adjust the scale and position of items within a node, you can add them to a child node and adjust them there
open class LocationNode: SCNNode {
    ///Location can be changed and confirmed later by SceneLocationView.
    public var location: CLLocation!
    
    ///Whether the location of the node has been confirmed.
    ///This is automatically set to true when you create a node using a location.
    ///Otherwise, this is false, and becomes true once the user moves 100m away from the node,
    ///except when the locationEstimateMethod is set to use Core Location data only,
    ///as then it becomes true immediately.
    public var locationConfirmed = false
    
    ///Whether a node's position should be adjusted on an ongoing basis
    ///based on its' given location.
    ///This only occurs when a node's location is within 100m of the user.
    ///Adjustment doesn't apply to nodes without a confirmed location.
    ///When this is set to false, the result is a smoother appearance.
    ///When this is set to true, this means a node may appear to jump around
    ///as the user's location estimates update,
    ///but the position is generally more accurate.
    ///Defaults to true.
    public var continuallyAdjustNodePositionWhenWithinRange = true
    
    ///Whether a node's position and scale should be updated automatically on a continual basis.
    ///This should only be set to false if you plan to manually update position and scale
    ///at regular intervals. You can do this with `SceneLocationView`'s `updatePositionOfLocationNode`.
    public var continuallyUpdatePositionAndScale = true
    
    public init(location: CLLocation?) {
        self.location = location
        self.locationConfirmed = location != nil
        super.init()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

open class LocationAnnotationNode: LocationNode {
    
    public let title: String
    public let deck: String
    public let date: String
    public let body: String
    public let image: UIImage
    public let icon: Icon
    public let type: Type
    public let url: String?


    public var scaleRelativeToDistance = true
    public let annotationNode: SCNNode

    public init(location: CLLocation?,title: String, deck: String, date: String, body: String, image: UIImage, icon: Icon, type: Type, url: String?) {
        self.title = title
        self.deck = deck
        self.date = date
        self.body = body
        self.image = image
        self.icon = icon
        self.type = type
        self.url = url


        annotationNode = SCNNode()
        let plane = SCNPlane(width: icon.ARimage.size.width, height: icon.ARimage.size.height)
        plane.firstMaterial!.diffuse.contents = icon.ARimage
        plane.firstMaterial!.lightingModel = .constant
        
        annotationNode.geometry = plane


        super.init(location: location)
        
        let billboardConstraint = SCNBillboardConstraint()
        billboardConstraint.freeAxes = SCNBillboardAxis.Y
        constraints = [billboardConstraint]
        
        addChildNode(annotationNode)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class StoryAnnotationNode: LocationNode {
    
    public let title: String
    public let deck: String
    public let date: String
    public let body: String
    public let image: UIImage

    public var scaleRelativeToDistance = true
    public let annotationNode: SCNNode
    
    public init(location: CLLocation?,title: String, deck: String, date: String, body: String, image: UIImage) {
        self.title = title
        self.deck = deck
        self.date = date
        self.body = body
        self.image = image

        
        let blackMaterial = SCNMaterial()
        blackMaterial.diffuse.contents = UIColor.black
        
        let whiteMaterial = SCNMaterial()
        whiteMaterial.diffuse.contents = UIColor.white
        
        let label = SCNText(string: title, extrusionDepth: 0.1)
        label.font = UIFont(name: "StagApp-Medium", size: 3.0)
        label.materials = [blackMaterial]
        
        annotationNode = SCNNode()
        annotationNode.geometry = label
        
        let plane = SCNPlane(width: 28, height: 5)
        plane.materials = [whiteMaterial]
        
        let planeNode = SCNNode()
        planeNode.geometry = plane
        planeNode.position = SCNVector3Make(11, 2, -2)
        
        let sphere = SCNSphere(radius: 1.20)
        sphere.firstMaterial!.diffuse.contents = UIColor.red
        sphere.firstMaterial!.specular.contents = UIColor.white
        
        let sphereNode = SCNNode()
        sphereNode.geometry = sphere
        sphereNode.position = SCNVector3Make(-5, 2, 0)
        
        let touchSphere = SCNSphere(radius: 10.0)
        touchSphere.firstMaterial?.transparency = 0.0
        
        let touchSphereNode = SCNNode()
        touchSphereNode.geometry = touchSphere
        touchSphereNode.position = SCNVector3Make(3, 0, 0)
        
        
        super.init(location: location)
        
        let billboardConstraint = SCNBillboardConstraint()
        billboardConstraint.freeAxes = SCNBillboardAxis.Y
        constraints = [billboardConstraint]
        
        addChildNode(annotationNode)
        addChildNode(sphereNode)
        addChildNode(touchSphereNode)
        addChildNode(planeNode)
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

