//
//  ReminderListView.swift
//  RemindersApp
//
//  Created by Atul Mane on 24/08/24.
//

import SwiftUI
import SwiftData

struct ReminderListView: View {
      
    let reminders: [Reminder]
    
    @Environment(\.modelContext) private var context
    
    @State private var showReminderEditScreen: Bool = false
    @State private var selectedReminder: Reminder?

    private let delay = Delay()
    
    @State private var reminderIdAndDelay: [PersistentIdentifier: Delay] = [:]
    
    private func deleteReminder(_ indexSet: IndexSet) {
        
        guard let index = indexSet.first else { return }
        let reminder = reminders[index]
        
        context.delete(reminder)
    }

    var body: some View {
        
        List {
            ForEach(reminders) { reminder in
                ReminderCellView(reminder: reminder) { event in
                    
                    switch event {
                    case .onCheck(let reminder, let checked):
                        
                        var delay = reminderIdAndDelay[reminder.persistentModelID]
                        
                        if let delay {
                            delay.cancel()
                            reminderIdAndDelay.removeValue(forKey: reminder.persistentModelID)
                        } else {
                            
                            delay = Delay()
                            reminderIdAndDelay[reminder.persistentModelID] = delay
                            
                            delay?.performWork {
                                reminder.isCompleted = checked
                            }
                        }
                        
                    case .onSelected(let reminder):
                        selectedReminder = reminder
                    }
                }
            }
            .onDelete(perform: deleteReminder)
        }
        .sheet(item: $selectedReminder, content: { selectedReminder in
            NavigationStack {
                ReminderEditScreen(reminder: selectedReminder)
            }
        })
    }
}

struct ReminderListViewContainer: View {
    
    @Query private var reminder: [Reminder]

    var body: some View {
        ReminderListView(reminders: reminder)
    }
}

#Preview { @MainActor in

    NavigationStack {
        ReminderListViewContainer()
    }
    .modelContainer(previewContainer)
}
