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
    case General
    
    var image: UIImage {
        switch self {
        case .General: return #imageLiteral(resourceName: "pin")
        }
    }
}

enum Type: String {
    case Story
    case ARVideo
    case ARPhoto
    
}


