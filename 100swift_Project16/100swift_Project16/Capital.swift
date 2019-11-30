//
//  Capital.swift
//  100swift_Project16
//
//  Created by MAC on 25/11/2019.
//  Copyright © 2019 Gera Volobuev. All rights reserved.
//

import MapKit
import UIKit

class Capital: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String
    
    init(title: String, coordinate: CLLocationCoordinate2D, info: String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
    }
}
