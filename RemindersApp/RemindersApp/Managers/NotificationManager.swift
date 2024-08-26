//
//  NotificationManager.swift
//  RemindersApp
//
//  Created by Atul Mane on 24/08/24.
//

import Foundation
import UserNotifications


struct UserData {
    
    let title: String?
    let body: String?
    let date: Date?
    let time: Date?
}

struct NotificationManager {
    
    static func scheduleNotification(userData: UserData) {
        
        let content = UNMutableNotificationContent()
        content.title = userData.title ?? "Notification from reminder app"
        content.body = userData.body ?? ""
        
       var dateComponants = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: userData.date ?? Date())

        if let reminderTime = userData.time {
            
            let reminderTimeDateComponants = reminderTime.dateComponants
            
            dateComponants.hour = reminderTimeDateComponants.hour
            dateComponants.minute = reminderTimeDateComponants.minute
        }
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponants, repeats: false)
        let request = UNNotificationRequest(identifier: "Reminder Notification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
}
