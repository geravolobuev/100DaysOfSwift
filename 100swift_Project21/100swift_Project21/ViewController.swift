//
//  ViewController.swift
//  100swift_Project21
//
//  Created by MAC on 04/12/2019.
//  Copyright © 2019 Gera Volobuev. All rights reserved.
//

import UserNotifications
import UIKit

class ViewController: UIViewController, UNUserNotificationCenterDelegate{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocal))
    }
    
    
    
    @objc func registerLocal() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Yay")
            } else {
                print("Douh")
            }
        }
    }
    
    @objc func scheduleLocal() {
        registerCategories()
        
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "Late wake up call"
        content.body = "The early bird catches the worm..."
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData" : "fizzbuzz"]
        content.sound = .default
        
        var dateComponets = DateComponents()
        dateComponets.hour = 15
        dateComponets.minute = 38
        
//                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponets, repeats: true)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false) // for debuging
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let show = UNNotificationAction(identifier: "show", title: "Tell me more", options: .foreground)
        let later = UNNotificationAction(identifier: "later", title: "Remind me later", options: .foreground)
        let category = UNNotificationCategory(identifier: "alarm", actions: [show, later], intentIdentifiers: [], options: [])
        center.setNotificationCategories([category])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        let ac = UIAlertController(title: "Action", message: "Ok", preferredStyle: .alert)
        if let customData = userInfo["customData"] as? String {
            print("customData received \(customData)")
            switch response.actionIdentifier  {
            case UNNotificationDefaultActionIdentifier:
                //the user swiped to unlock
                print("Default identifier")
                ac.addAction(UIAlertAction(title: "default id", style: .default))
                 present(ac, animated: true)
            case "show":
                print("show more info")
                ac.addAction(UIAlertAction(title: "show more info", style: .default))
                 present(ac, animated: true)
            case "later":
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { self.scheduleLocal()
                }
            default:
                break
            }
           
        }
        completionHandler()
    }
}


