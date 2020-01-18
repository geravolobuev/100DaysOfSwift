//
//  ViewController.swift
//  100swift_Project28
//
//  Created by MAC on 10/01/2020.
//  Copyright © 2020 Gera Volobuev. All rights reserved.
//

import LocalAuthentication
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var secret: UITextView!
    let lockBtn = UIBarButtonItem(title: "lock", style: .plain, target: self, action: #selector(lock))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Nothing to see here."
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(saveSecretMessage), name: UIApplication.willResignActiveNotification, object: nil)
        
        navigationItem.leftBarButtonItem = lockBtn
        lockBtn.isEnabled = false
        
    }
    
    @objc func lock() {
        saveSecretMessage()
        secret.isHidden = true
        title = "Nothing to see here."
        lockBtn.isEnabled = false
    }
    
    @IBAction func authenticateTapped(_ sender: Any) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Indentify yourself!"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        self?.unlockSecretMessage()
                        self?.lockBtn.isEnabled = true
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
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as?
            NSValue else { return }
        
        let keyboardScreenEnd = keyboardValue.cgRectValue
        let keyboardViewAndFrame = view.convert(keyboardScreenEnd, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            secret.contentInset = .zero
        } else {
            secret.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewAndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        secret.scrollIndicatorInsets = secret.contentInset
        
        let selectedRange = secret.selectedRange
        secret.scrollRangeToVisible(selectedRange)
    }
    
    func checkPassword() {
        let ac = UIAlertController(title: "Enter your password:", message: nil, preferredStyle: .alert)
        ac.addTextField { (textField) in
            textField.text = "Some default text"
        }
        
        if KeychainWrapper.standard.string(forKey: "password") != nil {
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak ac] (_) in
                guard let textField = ac?.textFields![0] else { return }
                let password = textField.text!
                if KeychainWrapper.standard.string(forKey: "password") == password {
                    self.unlockSecretMessage()
                    self.lockBtn.isEnabled = true
                } else {
                    let ac = UIAlertController(title: "Authentication failed!", message: "You could not be verified.", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "Ok", style: .default))
                    self.present(ac, animated: true)
                }
            }))
            
        } else {
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak ac] (_) in
                guard let textField = ac?.textFields![0] else { return }
                let password = textField.text!
                KeychainWrapper.standard.set(password, forKey: "password")
            }))
        }
        
        
        
        self.present(ac, animated: true)
    }
    
    func unlockSecretMessage() {
        secret.isHidden = false
        
        title = "Secret stuff!"
        
        secret.text = KeychainWrapper.standard.string(forKey: "SecretMessage") ?? ""
    }
    
    @objc func saveSecretMessage() {
        guard secret.isHidden == false else { return }
        
        KeychainWrapper.standard.set(secret.text, forKey: "SecretMessage")
        secret.resignFirstResponder()
        secret.isHidden = true
        title = "Nothing to see here."
    }
}

