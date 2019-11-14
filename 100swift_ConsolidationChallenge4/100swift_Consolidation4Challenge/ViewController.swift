//
//  ViewController.swift
//  100swift_Consolidation4Challenge
//
//  Created by MAC on 29/10/2019.
//  Copyright © 2019 Gera Volobuev. All rights reserved.
//


/// The challenge is this:make a hangman game using UIKit. As a reminder, this means choosing a random word from a list of possibilities, but presenting it to the user as a series of underscores. So, if your word was “RHYTHM” the user would see “??????”. The user can then guess letters one at a time: if they guess a letter that it’s in the word, e.g. H, it gets revealed to make “?H??H?”; if they guess an incorrect letter, they inch closer to death. If they seven incorrect answers they lose, but if they manage to spell the full word before that they win. ///

import UIKit



class ViewController: UIViewController {
    
    var lives = 7 {
        didSet {
            livesLabel.text = "You have \(lives) lives"
        }
    }

    @IBOutlet var livesLabel: UILabel!
    var allWords = [String]()
    var originalWord: String = ""
    var cypheredWord = [String]()
    @IBOutlet var cypheredWordLabel: UILabel!
    @IBOutlet var userInputField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Challenge 4"
        
        livesLabel.text = "You have 7 lives"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "restart", style: .plain, target: self, action: #selector(newGame))
        if let startWordsPath = Bundle.main.path(forResource: "start", ofType: "txt") {
            if let startWords = try? String(contentsOfFile: startWordsPath) {
                allWords = startWords.components(separatedBy: "\n")
            }
        } else {
            allWords = ["silkworm"]
        }
        userInputField.becomeFirstResponder()
        // Add an event to call onDidChangeDate function when value is changed.
        userInputField.addTarget(self, action: #selector(findSimilar), for: .editingDidEndOnExit)
        
        newGame()
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 1   // 10 Limit Value
    }
    
    
    @objc func newGame() {
        lives = 7
        originalWord = allWords.randomElement()!
        print(originalWord) // *for debuging*
        cyphereWord(originalWord)
        print(cypheredWord) // *for debuging*
        cypheredWordLabel.text = cypheredWord.joined()
        
    }
    
    func cyphereWord(_ word: String) {
        cypheredWord.removeAll()
        let rand = Int.random(in: 1 ..< word.count)
        print("rand is \(rand)") 
        for (position, letter) in word.enumerated() {
            print(position)
            if position == rand {
                cypheredWord.append(String(letter))
            }
                cypheredWord.append("?")
        }
        cypheredWord.removeLast()
    }
    
    @objc func findSimilar() {
        let userInputWord = userInputField.text!.lowercased()
        var originalWordArray = originalWord.map { String($0) }
        if originalWordArray.contains(userInputWord) {
            for (place, _) in originalWordArray.enumerated() {
                if originalWordArray[place] == userInputWord {
                    cypheredWord[place] = userInputWord
                }
            }
        } else if lives == 0 {
            let ac = UIAlertController(title: "Oops!", message: "Seems like you have lost your live!", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Try again", style: .default))
            present(ac, animated: true)
            newGame()
        } else {
            let ac = UIAlertController(title: "Wrong", message: "There is no letter \(userInputWord) in that word\n You lost 1 live!", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default))
            present(ac, animated: true)
            lives -= 1
        }
        
        if cypheredWord.contains("?") == false {
            newGame()
        }
        userInputField.text = ""
        cypheredWordLabel.text = cypheredWord.joined()


    }
}


