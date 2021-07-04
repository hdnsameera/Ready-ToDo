//
//  AppNotification.swift
//  My List
//
//  Created by H.D.N.Sameera on 2021-02-05.
//

import Foundation
import SwiftUI
import NotificationCenter

// MARK: - APP NOTIFICATION
struct AppNotification {
    
    // MARK: - CALCULATE NUMBER OF SECONDS
    func calculateNumberOfSeconds(dueDate: Date) -> Double {
        if dueDate.timeIntervalSince(Date()) > 0 {
           return dueDate.timeIntervalSince(Date())
        } else {
            return 1.0
        }
    }
    
    // MARK: - REQUEST PERMISSION FOR NOTIFICATIONS
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - ICON BAGDE COUNT
    func showIconBadgeCount(badgeCount: Int) {
        UIApplication.shared.applicationIconBadgeNumber = badgeCount
    }
    
    // MARK: - SHOW NOTIFICATION
    func showNotification(list: String, title: String, subTitle: String, numberOfSeconds: Double) {
        let identifier = list + title
        
        let content = UNMutableNotificationContent()
        content.title = "Reminder from \(list)"
        content.subtitle = "Priority : " + subTitle
        content.body = title
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = title
        content.userInfo = ["customData":"fuzzbuzz "]
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: numberOfSeconds, repeats: false)
        
        // choose a random identifier
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        // add our notification request
        UNUserNotificationCenter.current()
            .add(request)
    }
    
    func removeAllPendingNotificationRequests() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
    
    func removeSingleNotification(list: String, task: String) {
        let identifiers : [String] = [list + task]
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: identifiers)
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
    }
    
}
