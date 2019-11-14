//
//  Picture.swift
//  100swift_ConsolidationChallenge5
//
//  Created by MAC on 09/11/2019.
//  Copyright © 2019 Gera Volobuev. All rights reserved.
//

import UIKit

class Picture: NSObject, NSCoding {
    var name: String
    var image: String
    
    init(name: String, image: String) {
    self.name = name
    self.image = image
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: "name") as! String
        let image = aDecoder.decodeObject(forKey: "image") as! String
        self.init(name: name, image: image)
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(image, forKey: "image")
    }

}
