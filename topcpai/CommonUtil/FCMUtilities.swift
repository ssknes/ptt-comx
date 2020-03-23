//
//  FCMUtilities.swift
//  SmartPay
//
//  Created by ATA on 7/1/2559 BE.
//  Copyright © 2559 Ruttanachai Auitragool. All rights reserved.
//

import Foundation
import Firebase
import AVFoundation
import FirebaseMessaging
import UserNotifications

class FCMUtilities {
    
    static func connectToFcm() {
        guard CredentialManager.shareInstance.fcmToken != "" else {
            return
        }
        Messaging.messaging().shouldEstablishDirectChannel = true
        
        /*
        //Messaging.messaging().connect { (error) in
            if error != nil {
                log.debug("Unable to connect with FCM. \(String(describing: error))")
            } else {
                log.debug("Connected to FCM.")
                log.debug("FCM token : \(CredentialManager.shareInstance.fcmToken)")
            }
        }*/
    }
    
    static func subscribeTopic(topicName: String) {
        log.debug("Subscribing topic : \(topicName)")
        Messaging.messaging().subscribe(toTopic: topicName)
    }
    
    static func receiveNotificationFromBackground(userInfo: [NSObject: AnyObject]) {
        print("%@", userInfo)
        let temp = userInfo as! [String: AnyObject]
        createLocalPushNotification(userInfo: temp)
    }
    
    static func  receiveNotificationFromForeground(userInfo: [NSObject: AnyObject]) {
        print("%@", userInfo)
        
        let temp = userInfo as! [String: AnyObject]
        createLocalPushNotification(userInfo: temp)
    }
    
    private static func createLocalPushNotification(userInfo: [String: AnyObject]) {
//        let title = userInfo["title"] as! String? ?? ""
//        let body = userInfo["body"] as! String? ?? ""
//        
//        // create a corresponding local notification
//        let notification = UILocalNotification()
//        
//        if #available(iOS 8.2, *) {
//            notification.alertTitle = title
//        }
//        notification.alertBody = body
//        notification.fireDate = Date()
//        notification.soundName = UILocalNotificationDefaultSoundName
//        notification.userInfo = userInfo
//        
//        // create a sound ID
//        let systemSoundID: SystemSoundID = 1016
//        AudioServicesPlaySystemSound (systemSoundID)
        
        if let aps = userInfo["aps"] as? [String: AnyObject] {
            if let alert = aps["alert"]  as? [String: String] {
                
                let title = alert["title"] ?? ""
                let body = alert["body"] ?? ""
                
                // create a corresponding local notification
                let notification = UNUserNotificationCenter.current()//UILocalNotification()
                let content = UNMutableNotificationContent()
                content.title = title
                content.body = body
                content.sound = .default
                content.userInfo = userInfo
                let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents(in: .current, from: Date()), repeats: false)
                // create a sound ID
                let systemSoundID: SystemSoundID = 1016
                AudioServicesPlaySystemSound (systemSoundID)
                let request = UNNotificationRequest.init(identifier: UUID().uuidString, content: content, trigger: trigger)
                notification.add(request)
            }
        }
    }
}
