//
//  Petition.swift
//  100swift_Project7
//
//  Created by MAC on 21/10/2019.
//  Copyright © 2019 Gera Volobuev. All rights reserved.
//

import Foundation

struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}
