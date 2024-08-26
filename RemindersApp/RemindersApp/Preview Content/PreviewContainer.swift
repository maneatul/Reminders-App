//
//  PreviewContainer.swift
//  RemindersApp
//
//  Created by Atul Mane on 23/08/24.
//

import SwiftData
import Foundation

@MainActor
var previewContainer: ModelContainer = {
    
    let container = try! ModelContainer(for: Item.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    for item in SampleData.myLists {
        container.mainContext.insert(item)
        item.reminders = SampleData.reminders
    }
    return container
}()


struct SampleData {
    
    static var myLists: [Item] {
        return [ Item(name: "Reminders", colorCode: "#34C759"), Item(name: "Backlog", colorCode: "#AF52DE")]
    }
    
    static var reminders: [Reminder] {
        return [ Reminder(title: "reminder 1"), Reminder(title: "reminder 2", note: "reminder 2 note", reminderDate: Date(), reminderTime: Date())]
    }
}
