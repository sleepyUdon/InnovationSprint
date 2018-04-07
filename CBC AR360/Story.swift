//
//  Story.swift
//  CBC AR360
//
//  Created by Viviane Chan on 2018-04-05.
//  Copyright © 2018 CBC. All rights reserved.
//

import Foundation
import UIKit

struct Story {
    
    let title: String?
    let deck: String
    let body: String
    let date: String
    let image: String
    let latitude: Double
    let longitude: Double
    let altitude: Double = 50.0
    let icon: Icon
    let type: Type
    let url: String?
}

enum Icon: String {
    case Location
    case Breaking
    case AR
    case Sports
    
    var image: UIImage {
        switch self {
        case .Location: return #imageLiteral(resourceName: "i_location_BW")
        case .Breaking: return #imageLiteral(resourceName: "i_breaking_BW")
        case .AR: return #imageLiteral(resourceName: "i_360_BW")
        case .Sports: return #imageLiteral(resourceName: "i_location_BW")
        }
    }
}

enum Type: String {
    case Location
    case Breaking
    case Sports
    case ARVideo
    case ARPhoto
    
}


