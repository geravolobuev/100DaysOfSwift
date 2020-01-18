//
//  ViewController.swift
//  Project25
//
//  Created by TwoStraws on 19/08/2016.
//  Modified by George Volobuev on 04/01/2020.
//
//  Copyright © 2016 Paul Hudson. All rights reserved.
//

import MultipeerConnectivity
import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MCSessionDelegate, MCBrowserViewControllerDelegate {
    var images = [UIImage]()
    
    @IBAction func Connected(_ sender: Any) {
        let usersList = mcSession.connectedPeers
        print(usersList)
        let ac = UIAlertController(title: "Curently connected", message: "\(usersList)", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default))
        present(ac, animated: true)
    }
    var peerID: MCPeerID!
    var mcSession: MCSession!
    var mcAdvertiserAssistant: MCAdvertiserAssistant!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Selfie Share"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showConnectionPrompt))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(showImportActions))
        
        peerID = MCPeerID(displayName: UIDevice.current.name)
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession.delegate = self
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageView", for: indexPath)
        
        if let imageView = cell.viewWithTag(1000) as? UIImageView {
            imageView.image = images[indexPath.item]
        }
        
        return cell
    }
    
    @objc func showImportActions() {
        let ac = UIAlertController(title: "Text or pic?", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Picture", style: .default, handler: importPicture))
        ac.addAction(UIAlertAction(title: "Text", style: .default, handler: writeText))
        present(ac, animated: true)
        
    }
    
    func writeText(action: UIAlertAction) {
        let ac = UIAlertController(title: "Enter your text", message: nil, preferredStyle: .alert)
        ac.addTextField { (textField) in
            textField.text = "Some default text"
        }

        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak ac] (_) in
            let textField = ac?.textFields![0]
            self.sendText(text: textField!.text!)
        }))

        self.present(ac, animated: true)
    }
    
    func importPicture(action: UIAlertAction) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        dismiss(animated: true)
        
        images.insert(image, at: 0)
        collectionView?.reloadData()
        
        // 1
        if mcSession.connectedPeers.count > 0 {
            // 2
            if let imageData = image.pngData() {
                // 3
                do {
                    try mcSession.send(imageData, toPeers: mcSession.connectedPeers, with: .reliable)
                } catch {
                    let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    present(ac, animated: true)
                }
            }
        }
    }
    
    @objc func showConnectionPrompt() {
        let ac = UIAlertController(title: "Connect to others", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Host a session", style: .default, handler: startHosting))
        ac.addAction(UIAlertAction(title: "Join a session", style: .default, handler: joinSession))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "Leave the session", style: .destructive, handler: leaveSession))
        present(ac, animated: true)
    }
    
    func startHosting(action: UIAlertAction) {
        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "hws-project25", discoveryInfo: nil, session: mcSession)
        mcAdvertiserAssistant.start()
    }
    
    func joinSession(action: UIAlertAction) {
        let mcBrowser = MCBrowserViewController(serviceType: "hws-project25", session: mcSession)
        mcBrowser.delegate = self
        present(mcBrowser, animated: true)
    }
    
    func leaveSession(action: UIAlertAction) {
        mcSession.disconnect()
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        
        switch state {
        case MCSessionState.connected:
            print("Connected: \(peerID.displayName)")
            
        case MCSessionState.connecting:
            print("Connecting: \(peerID.displayName)")
            
        case MCSessionState.notConnected:
            print("Not Connected: \(peerID.displayName)")
            DispatchQueue.main.async { [weak self] in
                let notConnectedAC = UIAlertController(title: "Disconnected!", message: "\(peerID.displayName) has left the network", preferredStyle: .alert)
                notConnectedAC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self?.present(notConnectedAC, animated: true, completion: nil)
            }
        }
        
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        if let image = UIImage(data: data) {
            DispatchQueue.main.async { [unowned self] in
                self.images.insert(image, at: 0)
                self.collectionView?.reloadData()
            }
        } else {
            let text =  String(decoding: data, as: UTF8.self)
            DispatchQueue.main.async { [unowned self] in
                let ac = UIAlertController(title: "Message!", message: text, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Ok", style: .default))
                self.present(ac, animated: true)
            }
        }
    }
    
    func sendImage(img: UIImage) {
        if mcSession.connectedPeers.count > 0 {
            if let imageData = img.pngData() {
                do {
                    try mcSession.send(imageData, toPeers: mcSession.connectedPeers, with: .reliable)
                } catch let error as NSError {
                    let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    present(ac, animated: true)
                }
            }
        }
    }
    
    func sendText(text: String) {
        if mcSession.connectedPeers.count > 0 {
            let textData = Data(text.utf8)
            do {
                try mcSession.send(textData, toPeers: mcSession.connectedPeers, with: .reliable)
            } catch let error as NSError {
                let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
            }
        }
    }
}

