//
//  StoryNode.swift
//  CBC AR360
//
//  Created by Viviane Chan on 2018-04-05.
//  Copyright © 2018 CBC. All rights reserved.
//

import Foundation
import MapKit

class StoryNode: NSObject, MKAnnotation {
    
    let title: String?
    let deck: String
    let body: String
    let date: String
    let image: String?
    let coordinate: CLLocationCoordinate2D
    let type: Type

    init(title: String, deck: String, body: String, date: String, image: String, coordinate: CLLocationCoordinate2D, type: Type) {
        self.title = title
        self.deck = deck
        self.body = body
        self.date = date
        self.image = image
        self.coordinate = coordinate
        self.type = type

        super.init()
    }
}
