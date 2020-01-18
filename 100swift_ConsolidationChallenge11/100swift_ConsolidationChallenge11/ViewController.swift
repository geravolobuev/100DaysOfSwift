//
//  ViewController.swift
//  100swift_ConsolidationChallenge11
//
//  Created by MAC on 14/01/2020.
//  Copyright © 2020 Gera Volobuev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var letterButtons = [UIButton]()
    var activatedButtons = [UIButton]()
    var currentAnswer = ""
    var correctAnswers = [String]()
    var score = 0 {
        didSet {
            if score == letterButtons.count {
                let ac = UIAlertController(title: "You Win!", message: nil, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Try again?", style: .default, handler: { (action) in
                    self.letterButtons.shuffle()
                    self.correctAnswers.removeAll()
                    self.activatedButtons.removeAll()
                    for i in self.letterButtons {
                        i.alpha = 1
                        i.backgroundColor = .black
                    }
                    self.score = 0
                    self.loadLevel()
                }))
                present(ac, animated: true)
                
            }
        }
    }
    
    override func loadView() {
        
        view = UIView()
        view.backgroundColor = .white
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        let width = Int(UIScreen.main.bounds.width / 4)
        let height = Int(UIScreen.main.bounds.height / 4) - 100
        
        NSLayoutConstraint.activate([
            buttonsView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 100),
            buttonsView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
            
        ])
        
        
        
        for row in 0..<4 {
            for column in 0..<3 {
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
                letterButton.setTitle("WWW", for: .normal)
                letterButton.backgroundColor = .black
                letterButton.tintColor = .black
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                letterButton.layer.borderWidth = 1
                letterButton.layer.borderColor = UIColor.lightGray.cgColor
                
                let frame = CGRect(x: column * width, y: row * height, width: width, height: height)
                letterButton.frame = frame
                
                buttonsView.addSubview(letterButton)
                letterButtons.append(letterButton)
            }
        }
    }
    
    @objc func changeCard() {
        if let ChangeCardVC = storyboard?.instantiateViewController(withIdentifier: "ChangeCard") as? ChangeCardViewController {
            // do smth here
        navigationController?.pushViewController(ChangeCardVC, animated: true)
        }
    }
    
    
    @objc func letterTapped(_ sender: UIButton) {
        sender.backgroundColor = .white
        guard let buttonTitle = sender.titleLabel?.text else { return }
        if currentAnswer.isEmpty {
            currentAnswer += "\(buttonTitle)|"
        } else {
            currentAnswer += buttonTitle
        }
        
        activatedButtons.append(sender)
        
        if activatedButtons.count == 2 {
            var reverserdAnswer = currentAnswer.components(separatedBy: "|")
            reverserdAnswer = ["\(reverserdAnswer[1])|\(reverserdAnswer[0])"]
            if correctAnswers.contains(currentAnswer) || correctAnswers.contains(reverserdAnswer[0]) {
                for item in activatedButtons {
                    item.backgroundColor = .green
                    UIView.animate(withDuration: 2.5) {
                        item.alpha = 0
                    }
                }
                activatedButtons.removeAll()
                currentAnswer = ""
                score+=2
                
            } else {
                clearTapped()
                currentAnswer = ""
            }
        }
        
    }
    
    @objc func clearTapped() {
        
        currentAnswer = ""
        
        for button in activatedButtons {
            UIView.animate(withDuration: 2.5) {
                button.alpha = 1
                button.backgroundColor = .black
            }
            
        }
        
        activatedButtons.removeAll()
    }
    
    
    @objc func loadLevel() {
        var letterBits = [String]()
        DispatchQueue.global(qos: .userInitiated).async {
            if let levelFileUrl = Bundle.main.url(forResource: "level", withExtension: "txt") {
                if let levelContents = try? String(contentsOf: levelFileUrl) {
                    var lines = levelContents.components(separatedBy: "\n")
                    lines.shuffle()
                    
                    for (index, line) in lines.enumerated() {
                        let bits = line.components(separatedBy: "|")
                        letterBits += bits
                        
                        self.correctAnswers.append(line)
                    }
                }
            }
        }
        print(letterBits)
        DispatchQueue.main.async {
            
            self.letterButtons.shuffle()
            
            if self.letterButtons.count == letterBits.count {
                for i in 0..<self.letterButtons.count {
                    self.letterButtons[i].setTitle(letterBits[i], for: .normal)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadLevel()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Change cards", style: .plain, target: self, action: #selector(changeCard))
    }
    
    
}

