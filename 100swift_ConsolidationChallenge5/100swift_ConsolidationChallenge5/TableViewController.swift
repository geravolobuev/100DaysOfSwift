//
//  TableViewController.swift
//  100swift_ConsolidationChallenge5
//
//  Created by MAC on 09/11/2019.
//  Copyright © 2019 Gera Volobuev. All rights reserved.
//

import UIKit

let defaults = UserDefaults.standard

class TableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var userPic = [Picture]()  {
        didSet {
            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: userPic)
            defaults.setValue(encodedData, forKey: "userPic")
            defaults.synchronize()
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
        
        // check if user stored any data previously and insert it
        let decoded  = defaults.value(forKey: "userPic")
        let decodedTeams = NSKeyedUnarchiver.unarchiveObject(with: decoded as! Data)
        if decodedTeams != nil {
            userPic = decodedTeams as! [Picture]
        }
        
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
        
        let pic = Picture(name: "Unknow", image: imageName)
        userPic.append(pic)
        self.tableView.reloadData()
        dismiss(animated: true)
        
        let ac = UIAlertController(title: "Do you want to rename the picture?", message: nil, preferredStyle: .alert)
             ac.addAction(UIAlertAction(title: "Rename", style: .default) { [weak self, weak ac] _ in
                 guard let newName = ac?.textFields?[0].text else { return }
                pic.name = newName
                let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: self!.userPic)
                defaults.setValue(encodedData, forKey: "userPic")
                defaults.synchronize()
                 self?.tableView.reloadData()
             })
             ac.addTextField()
        self.present(ac, animated: true)

     
    }
    
    func getDocumentDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    // MARK: - Table view data source
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userPic.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath) as? PictureCell else {
            // we failed to get a PersonCell – bail out!
            fatalError("Unable to dequeue PersonCell.")
        }
        
        let caption = userPic[indexPath.item]
        let path = getDocumentDirectory().appendingPathComponent(caption.image)
        cell.thumbnailCaption.text = caption.name
        cell.thumbnailPic.image = UIImage(contentsOfFile: path.path)
        return cell
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Image") as? ViewController {
            // 2: success! Set its selectedImage property
            let image = userPic[indexPath.row]
            vc.selectedImage = getDocumentDirectory().appendingPathComponent(image.image)
            // 3: now push it onto the navigation controller
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.userPic.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
       
        return [delete]
    }
    
    
    
    
}


