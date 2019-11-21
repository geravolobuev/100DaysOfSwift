//
//  Person.swift
//  100swift_Project10
//
//  Created by MAC on 31/10/2019.
//  Copyright © 2019 Gera Volobuev. All rights reserved.
//

import UIKit

class Person: NSObject, Codable {
    var name: String
    var image: String
    
    init(name: String, image: String) {
    self.name = name
    self.image = image
    }
}
