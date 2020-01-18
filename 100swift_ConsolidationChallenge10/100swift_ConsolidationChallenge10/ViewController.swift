//
//  ViewController.swift
//  100swift_ConsolidationChallenge10
//
//  Created by MAC on 08/01/2020.
//  Copyright © 2020 Gera Volobuev. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var upperTextBtn: UIButton!
    @IBOutlet weak var buttomTextBtn: UIButton!
    
    var selectedImage: UIImage!
    
    var upperText = "" {
        didSet {
            guard let pic = selectedImage else { return }
            drawText(pic)
        }
    }
    var bottomText = "" {
        didSet {
            guard let pic = selectedImage else { return }
            drawText(pic)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        upperTextBtn.addTarget(self, action: #selector(writeUpperText), for: .touchUpInside)
        buttomTextBtn.addTarget(self, action: #selector(writeBottomText), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(share))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(importPic))
        // Do any additional setup after loading the view.
    }
    
    @objc func writeUpperText() {
        
        let upperTextAc = UIAlertController(title: "Enter your upper text:", message: nil, preferredStyle: .alert)
        upperTextAc.addTextField { (textField) in
            textField.text = "Some default text"
        }
        
        upperTextAc.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak upperTextAc] (_) in
            guard let textField = upperTextAc?.textFields![0] else { return }
            self.upperText = textField.text!
        }))
        
        self.present(upperTextAc, animated: true)
        
    }
    
    @objc func writeBottomText() {
        let bottomTextAC = UIAlertController(title: "Enter your bottom text:", message: nil, preferredStyle: .alert)
        bottomTextAC.addTextField { (textField) in
            textField.text = "Some default text"
        }
        
        bottomTextAC.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak bottomTextAC] (_) in
            guard let textField = bottomTextAC?.textFields![0] else { return }
            self.bottomText = textField.text!
        }))
        
        self.present(bottomTextAC, animated: true)
    }
    
    func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        dismiss(animated: true)
        imageView.image = image
        selectedImage = imageView.image
    }
    
    @objc func share() {

        guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else {
                 print("No image found!")
                 return
             }
             
             let vc = UIActivityViewController(activityItems: [image, title!], applicationActivities: [])
             vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
             
             present(vc, animated: true)
    }
    
    func drawText(_ pic: UIImage) {
        // 1
        let imgSize = selectedImage.size
        let renderer = UIGraphicsImageRenderer(size: imgSize)

        let img = renderer.image { ctx in
            
                pic.draw(at: CGPoint(x: 0, y: 0))
            // 2
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center

            // 3
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 76),
                .foregroundColor: UIColor.white,
                .paragraphStyle: paragraphStyle
            ]

            // 4
            let topString = NSAttributedString(string: upperText, attributes: attrs)
            let bottomString = NSAttributedString(string: bottomText, attributes: attrs)
            
            // 5
            topString.draw(with: CGRect(x: 50, y: 50, width: pic.size.width - 100, height: pic.size.height / 2), options: .usesLineFragmentOrigin, context: nil)
            bottomString.draw(with: CGRect(x: 50, y: pic.size.height - 100, width: pic.size.width - 100, height: pic.size.height / 2), options: .usesLineFragmentOrigin, context: nil)

        }

        // 6
        imageView.image = img
    }
    
    
    
    @objc func importPic() {
        
        importPicture()
        
        
    }
    
}

