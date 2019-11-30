//
//  ViewController.swift
//  100swift_Project18
//
//  Created by MAC on 28/11/2019.
//  Copyright © 2019 Gera Volobuev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("inside of didLoad method")
        print(1, 2, 3, 4, 5, separator: "|")
        print("some mesg", terminator: "____")
        
        assert(1 == 1, "Math failure")
        assert(1 == 2, "Math failure")
        
        for i in 1 ... 100 {
            print("Got number \(i)")
        }
    }


}

