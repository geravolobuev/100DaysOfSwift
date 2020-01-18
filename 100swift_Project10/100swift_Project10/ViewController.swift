//
//  ViewController.swift
//  100swift_Project10
//
//  Created by MAC on 30/10/2019.
//  Copyright © 2019 Gera Volobuev. All rights reserved.
//
import LocalAuthentication
import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var people = [Person]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let notificationCenter = NotificationCenter.default
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Login", style: .plain, target: self, action: #selector(authenticate))
        
        collectionView.isHidden = true
        notificationCenter.addObserver(self, selector: #selector(savePhotos), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
            fatalError("Unable to dequeue PersonCell")
        }
        
        let person = people[indexPath.item]
        cell.name.text = person.name
        
        let path = getDocumentDirectory().appendingPathComponent(person.image)
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 3
        return cell
        
    }
    
    @objc func addNewPerson() {
        let picker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        }
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        let imageName = UUID().uuidString
        let imagePath = getDocumentDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        let person = Person(name: "Unknow", image: imageName)
        people.append(person)
        collectionView.reloadData()
        dismiss(animated: true)
    }
    
    func getDocumentDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.item]
        let ac = UIAlertController(title: "Do you want to remove or rename the person?", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Rename", style: .default) { [weak self, weak ac] _ in
            guard let newName = ac?.textFields?[0].text else { return }
            person.name = newName
            self?.collectionView.reloadData()
        })
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Remove", style: .default, handler: { action in
            self.people.removeAll { $0 == person }
            self.collectionView.reloadData()
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
        
    }
    
    @objc func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Indentify yourself!"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        self?.unlockPhotos()
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
                    self.unlockPhotos()
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
    
    func unlockPhotos() {
        collectionView.isHidden = false
    }
    
    @objc func savePhotos() {
        collectionView.isHidden = true
    }
    
    
}

