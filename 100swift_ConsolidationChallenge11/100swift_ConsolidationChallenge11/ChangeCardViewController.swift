//
//  ChangeCardViewController.swift
//  100swift_ConsolidationChallenge11
//
//  Created by MAC on 17/01/2020.
//  Copyright © 2020 Gera Volobuev. All rights reserved.
//

import UIKit


class ChangeCardViewController: UITableViewController {
    
    weak var delegate: CollectionViewController?
    var currentCards = [String]() {
        didSet {
            delegate?.passCards(type: currentCards)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add new card", style: .plain, target: self, action: #selector(addNewCard))
    }
    
    @objc func addNewCard() {
        var newCard = ""
        let ac = UIAlertController(title: "Add New Card", message: "", preferredStyle: .alert)
        ac.addTextField { (textField : UITextField!) -> Void in
              textField.placeholder = "Enter First Word"
          }
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
              let firstTextField = ac.textFields![0] as UITextField
            newCard = "\(firstTextField.text!)|"
              let secondTextField = ac.textFields![1] as UITextField
            newCard += secondTextField.text!
            self.currentCards.append(newCard)
            self.tableView.reloadData()

          })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
              (action : UIAlertAction!) -> Void in })
        ac.addTextField { (textField : UITextField!) -> Void in
              textField.placeholder = "Enter Second Word"
          }

          ac.addAction(saveAction)
          ac.addAction(cancelAction)

        self.present(ac, animated: true, completion: nil)

    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentCards.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell    (withIdentifier: "CardTableCell", for: indexPath)
        cell.textLabel?.text = currentCards[indexPath.row]
        
        return cell
    }
}
