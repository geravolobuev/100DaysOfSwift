//
//  ViewController.swift
//  100swift_Project7
//
//  Created by MAC on 21/10/2019.
//  Copyright © 2019 Gera Volobuev. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var petitions = [Petition]()
    var filtered = [Petition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "White Houes Petitions"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(showCredits))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(filterEntries))
        
        
        let urlString: String
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
            
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        func startAll() {
            if let url = URL(string: urlString) {
                if let data = try? Data.init(contentsOf: url) {
                    parse(json: data)
                    return
                }
            }
            showError()
        }
        startAll()
    }
    
    func refresher () {
        petitions = filtered
        tableView.reloadData()
    }
    
    @objc func showCredits() {
        let ac = UIAlertController(title: "Credits", message: "All data comes from the We The People API of the Whitehouse.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default))
        present(ac, animated: true)
    }
    
    func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading a feed. Please check your connection and try again", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func parse(json: Data) {
        DispatchQueue.global(qos: .userInitiated).async {
            let decoder = JSONDecoder()
            
            if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
                self.petitions = jsonPetitions.results
                self.filtered = self.petitions
                self.tableView.reloadData()
            }
        }
    }
    
    func filterParse(json: Data) {
        
        let decoder = JSONDecoder()
        let filterWord = "Trump"
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results.filter { filterWord.contains($0.title) }
            tableView.reloadData()
        }
        
    }
    
    
    @objc func filterEntries() {
        let ac = UIAlertController(title: "Enter your text", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Filter", style: .default) { [unowned self, ac] action in
            let answer = ac.textFields![0]
            
            self.submit(answer: answer.text!)
        }
        
        ac.addAction(submitAction)
        ac.addAction(UIAlertAction.init(title: "Refresh", style: .default, handler: { (action) in
            self.refresher()
        }))
        present(ac, animated: true)
        
    }
    
    func submit(answer: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.petitions.removeAll(keepingCapacity: true)
            for title in self.filtered {
                if title.title.contains(answer) {
                    self.petitions.insert(title, at: 0)
                }
            }
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return petitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let petition = petitions[indexPath.row]
        
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

