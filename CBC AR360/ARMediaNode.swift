//
//  ARMediaNode.swift
//  CBC AR360
//
//  Created by Viviane Chan on 2018-04-05.
//  Copyright © 2018 CBC. All rights reserved.
//

import Foundation
import MapKit

class ARMediaNode: NSObject, MKAnnotation {
    
    let title: String?
    let url: String?
    let type: Type
    let coordinate: CLLocationCoordinate2D

    
    init(title: String, url: String, type: Type, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.url = url
        self.type = type
        self.coordinate = coordinate

        super.init()
    }
}




