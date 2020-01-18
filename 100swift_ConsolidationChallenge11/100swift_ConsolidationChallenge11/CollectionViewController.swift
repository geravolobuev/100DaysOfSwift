//
//  CollectionViewController.swift
//  100swift_ConsolidationChallenge11
//
//  Created by MAC on 18/01/2020.
//  Copyright © 2020 Gera Volobuev. All rights reserved.
//

import UIKit
import LocalAuthentication

protocol CardsDelegate
{
    func passCards(type: [String])
}

class CollectionViewController: UICollectionViewController, CardsDelegate {
    
    var activatedCells = [UICollectionViewCell]()
    var currentAnswer = ""
    var correctAnswers = [String]()
    var letterBits = [String]()
    var score = 0 {
        didSet {
            if score == correctAnswers.count {
                let ac = UIAlertController(title: "You Win!", message: nil, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Try again?", style: .default, handler: { (action) in
                    self.currentAnswer = ""
                    self.score = 0
                    self.activatedCells.removeAll()
                    for i in self.collectionView.visibleCells {
                        i.alpha = 1
                        i.backgroundColor = .black
                    }
                    
                    self.loadLevel()
                    self.collectionView.reloadData()
                }))
                present(ac, animated: true)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadLevel()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Change cards", style: .plain, target: self, action: #selector(authenticate))
    }
    
    func passCards(type: [String])
    {
        correctAnswers = type
        self.currentAnswer = ""
        self.score = 0
        self.activatedCells.removeAll()
        for i in self.collectionView.visibleCells {
            i.alpha = 1
            i.backgroundColor = .black
        }
        loadLevel()
        collectionView.reloadData()
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return letterBits.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Card", for: indexPath) as? CardCell else {
            // we failed to get a PersonCell – bail out!
            fatalError("Unable to dequeue PersonCell.")
        }
        
        // Configure the cell
        
        let card = letterBits[indexPath.item]
        cell.cellLabel.text = card
        cell.backgroundColor = .black
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let card = letterBits[indexPath.item]
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        
        cell.backgroundColor = .white
        if currentAnswer.isEmpty {
            currentAnswer += "\(card)|"
        } else {
            currentAnswer += card
        }
        
        activatedCells.append(cell)
        
        if activatedCells.count == 2 {
            var reverserdAnswer = currentAnswer.components(separatedBy: "|")
            reverserdAnswer = ["\(reverserdAnswer[1])|\(reverserdAnswer[0])"]
            if correctAnswers.contains(currentAnswer) || correctAnswers.contains(reverserdAnswer[0]) {
                for item in activatedCells {
                    item.backgroundColor = .green
                    UIView.animate(withDuration: 2.5) {
                        item.alpha = 0
                    }
                }
                activatedCells.removeAll()
                currentAnswer = ""
                score+=1
                
            } else {
                clearTapped()
                currentAnswer = ""
            }
        }
    }
    
    func loadLevel() {
        if correctAnswers.isEmpty {
            if let levelFileUrl = Bundle.main.url(forResource: "level", withExtension: "txt") {
                if let levelContents = try? String(contentsOf: levelFileUrl) {
                    var lines = levelContents.components(separatedBy: "\n")
                    lines.shuffle()
                    
                    for (index, line) in lines.enumerated() {
                        let bits = line.components(separatedBy: "|")
                        self.letterBits += bits
                        self.correctAnswers.append(line)
                    }
                }
            }
        } else {
            letterBits.removeAll()
            for index in correctAnswers {
                let bits = index.components(separatedBy: "|")
                self.letterBits += bits
            }
        }
        letterBits.shuffle()

    }
    
    func changeCard() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "ChangeCard") as? ChangeCardViewController {
            // do smth here
            navigationController?.pushViewController(vc, animated: true)
            vc.currentCards = correctAnswers
            vc.delegate = self
        }
    }
    
    
    @objc func clearTapped() {
        
        currentAnswer = ""
        for item in activatedCells {
            UIView.animate(withDuration: 2.5) {
                item.alpha = 1
                item.backgroundColor = .black
            }
        }
        activatedCells.removeAll()
    }
    
    @objc func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Indentify yourself!"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        self?.changeCard()
                    } else {
                        // error
                        let ac = UIAlertController(title: "Authentication failed!", message: "You could not be verified.", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "Ok", style: .default))
                        self?.present(ac, animated: true)
                    }
                }
            }
        } else {
            // NO BIOMETRY
            checkPassword()
        }
    }
    
    func checkPassword() {
        let ac = UIAlertController(title: "Enter your password:", message: nil, preferredStyle: .alert)
        ac.addTextField { (textField) in
            
        }
        
        if KeychainWrapper.standard.string(forKey: "password") != nil {
            ac.addAction(UIAlertAction(title: "Login", style: .default, handler: { [weak ac] (_) in
                guard let textField = ac?.textFields![0] else { return }
                let password = textField.text!
                if KeychainWrapper.standard.string(forKey: "password") == password {
                    self.changeCard()
                } else {
                    let ac = UIAlertController(title: "Authentication failed!", message: "You could not be verified.", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "Ok", style: .default))
                    self.present(ac, animated: true)
                }
            }))
            
        } else {
            ac.addAction(UIAlertAction(title: "Register password", style: .default, handler: { [weak ac] (_) in
                guard let textField = ac?.textFields![0] else { return }
                let password = textField.text!
                KeychainWrapper.standard.set(password, forKey: "password")
            }))
        }
        
        self.present(ac, animated: true)
    }
    
}
