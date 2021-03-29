//
//  AddNotification.swift
//  XpiryTracker
//
//  Created by Qihang on 2020/10/10.
//  Copyright © 2020 nakhat. All rights reserved.
//

import Foundation
import UserNotifications

class AddNotification{
    static let sharedInstance = AddNotification()
    
    func setNotification(alertDate: String, productName: String, qty: String){
        
        let content = UNMutableNotificationContent()
        content.title = "XpiryTracker"
        content.body = "\(qty) \(productName) is expirying soon"
        
        var date = alertDate.components(separatedBy: "/")
        
        var components = DateComponents()
        components.year = Int(date[2])
        components.month = Int(date[1])
        components.day = Int(date[0])
        components.hour = 9
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        //        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        
        let requestIdentifier = "notification"
        
        let request = UNNotificationRequest(identifier: requestIdentifier,content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if error == nil {
                print("Time Interval Notification scheduled: \(requestIdentifier)")
                print(components)
            }
        }
    }
}
