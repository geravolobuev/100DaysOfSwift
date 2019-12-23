//
//  ViewController.swift
//  100swift_ConsolidationChallenge8
//
//  Created by MAC on 15/12/2019.
//  Copyright © 2019 Gera Volobuev. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextViewDelegate {
    
    var delegate: TableViewController?
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    
    var doneBtn = UIBarButtonItem(barButtonSystemItem: .save
        , target: self
        , action: #selector(done))
    
    var notePosition = 0
    var startValue = Note(noteText: "", noteDate: "")
    var userInput = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateLabel.text = startValue.noteDate
        textView.text = startValue.noteText
        doneBtn.isEnabled = false
        doneBtn.tintColor = .clear
        self.textView.delegate = self;
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        let shareBtn = UIBarButtonItem(barButtonSystemItem: .action
             , target: self
             , action: #selector(share))
    
        navigationItem.setRightBarButtonItems([shareBtn, doneBtn], animated: true)
    
        // Toolbar buttons setup
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let delete = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(deleteNote))
        let add = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(addNote))


        toolbarItems = [delete, spacer, add]
        navigationController?.isToolbarHidden = false
        
    }

    func getDate() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy, HH:mm"
        let dayToday = formatter.string(from: date)
        return dayToday
    }

    @objc func done() {
        textView.resignFirstResponder()
        doneBtn.isEnabled = false
        doneBtn.tintColor = .clear
        userInput = textView.text
        dateLabel.text = getDate()
        
        if startValue.noteText == "" {
            delegate?.addToArray(newNote: Note(noteText: userInput, noteDate: getDate()))
        } else {
            delegate?.editArray(newNote: userInput, oldNote: startValue.noteText)
            startValue.noteText.removeAll()
        }
    }
    
    @objc func deleteNote() {

        delegate?.notes.remove(at: notePosition)
        delegate?.tableView.reloadData()
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func addNote() {
        textView.text = ""
        textView.becomeFirstResponder()
    }
    
    @objc func share() {
        let vc = UIActivityViewController(activityItems: [textView.text], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        
        present(vc, animated: true)
         print(userInput)
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            textView.contentInset = .zero
        } else {
            textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
            doneBtn.isEnabled = true
            doneBtn.tintColor = .systemYellow
        }

        textView.scrollIndicatorInsets = textView.contentInset

        let selectedRange = textView.selectedRange
        textView.scrollRangeToVisible(selectedRange)
    }
}

