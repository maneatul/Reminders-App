//
//  RemindersAppApp.swift
//  RemindersApp
//
//  Created by Atul Mane on 24/08/24.
//

import SwiftUI
import UserNotifications

@main
struct RemindersAppApp: App {
    
    init() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { _, _ in
            
        })
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                MyListScreen()
                    .modelContainer(for: Item.self)
            }
        }
    }
}
