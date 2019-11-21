//
//  DetailViewController.swift
//  100swift_ConsolidationChallenge6
//
//  Created by MAC on 22/11/2019.
//  Copyright © 2019 Gera Volobuev. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    var detailItem: Country?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let item = detailItem else { return }
        nameLabel.text = item.title
        bodyLabel.text = item.body
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
