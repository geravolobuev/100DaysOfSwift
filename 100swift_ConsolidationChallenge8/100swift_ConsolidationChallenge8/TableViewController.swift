//
//  TableViewController.swift
//  100swift_ConsolidationChallenge8
//
//  Created by MAC on 15/12/2019.
//  Copyright © 2019 Gera Volobuev. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

   
    var spacer = UIBarButtonItem()
    var notesAmount = UIBarButtonItem()
    var add = UIBarButtonItem()
    var notesCount = 0
    let defaults = UserDefaults.standard
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    var notes = [Note]() {
        didSet {
            notesCount = notes.count
            notesAmount.title = "\(notesCount) notes"
            if let encoded = try? encoder.encode(notes) {
                defaults.set(encoded, forKey: "notes")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "bg-notes.png")
        backgroundImage.contentMode = UIView.ContentMode.scaleToFill
        self.view.insertSubview(backgroundImage, at: 0)
        
        self.title = "Notes"
        
        spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        notesAmount = UIBarButtonItem(title: "0 notes", style: .plain, target: self, action: nil)
        add = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(addNote))


        tableView.reloadData()
        
        toolbarItems = [spacer, notesAmount, spacer, add]
        navigationController?.isToolbarHidden = false
        
        if let savedNotes = defaults.object(forKey: "notes") as? Data {
            if let loadedNotes = try? decoder.decode([Note].self, from: savedNotes) {
                notes = loadedNotes
            }
        }

    }

    @objc func addNote() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Note") as? ViewController {
            navigationController?.pushViewController(vc, animated: true)
            vc.delegate = self
            if notes.count == 0 {
                vc.notePosition = 0
            } else {
                vc.notePosition = notes.count + 1
            }
        }
    }
    
    func addToArray(newNote: Note) {
        notes.append(newNote)
        tableView.reloadData()
    }
    
    func editArray(newNote: String, oldNote: String) {
        if let row = notes.firstIndex(where: {$0.noteText == oldNote}) {
            notes[row].noteText = newNote
            tableView.reloadData()
        }
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath)
        cell.textLabel?.text = notes[indexPath.row].noteText
        cell.detailTextLabel?.text = notes[indexPath.row].noteDate
        return cell
    }


    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, complete in
            self.notes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            complete(true)
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Note") as? ViewController {
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
            vc.startValue = notes[indexPath.row]
            vc.notePosition = indexPath.row
        }
    }
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */


    // MARK: - Navigation

    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
