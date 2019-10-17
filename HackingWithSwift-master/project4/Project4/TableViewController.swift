//
//  TableViewController.swift
//  Project4
//
//  Created by MAC on 16/10/2019.
//  Copyright © 2019 Paul Hudson. All rights reserved.
//

import UIKit

var websites = ["apple.com", "hackingwithswift.com", "example.com"]
class TableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    // This chages parent method.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return websites.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = websites[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 1: try loading the "Detail" view controller and typecasting it to be DetailViewController
        if let vc = storyboard?.instantiateViewController(withIdentifier: "WebView") as? ViewController {
            // 2: success! Set its selectedImage property
            vc.webSiteToLoad = websites[indexPath.row]
            
            // 3: now push it onto the navigation controller
            if vc.goodWebsites.contains(vc.webSiteToLoad!) {
            navigationController?.pushViewController(vc, animated: true)
            } else {
                let ac = UIAlertController(title: "Wrong URL!", message: "You dont have permission to visit this site!", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Close", style: .default))
                present(ac, animated: true)
            }
        }
    }
}
