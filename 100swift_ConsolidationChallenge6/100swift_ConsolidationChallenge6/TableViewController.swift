//
//  TableViewController.swift
//  100swift_ConsolidationChallenge6
//
//  Created by MAC on 21/11/2019.
//  Copyright © 2019 Gera Volobuev. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var countries = [Country]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("start")
        parseJSON()
    }
    
    func parseJSON(){
        if let path = Bundle.main.path(forResource: "text", ofType: "txt") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONDecoder().decode(Countries.self, from: data)
                    countries = jsonResult.results
            } catch {
               print(error)
            }
        }
    }
    
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return countries.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Country", for: indexPath)
        
        let country = countries[indexPath.row]
        cell.textLabel?.text = country.title
        // Configure the cell...
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
        vc.detailItem = countries[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
        }

    }

    
}
