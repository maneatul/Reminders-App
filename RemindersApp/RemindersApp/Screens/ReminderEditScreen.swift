//
//  ReminderEditScreen.swift
//  RemindersApp
//
//  Created by Atul Mane on 23/08/24.
//

import SwiftUI
import SwiftData

struct ReminderEditScreen: View {
    
    let reminder: Reminder
    
    @Environment(\.dismiss) private var dismiss
    @State private var title: String = ""
    @State private var note: String = ""
    @State private var reminderDate: Date = .now
    @State private var reminderTime: Date = .now
    
    @State private var showCalendar: Bool = false
    @State private var showTime: Bool = false
    
    private var isFormValid: Bool {
        !title.isEmptyOrWhitespaces
    }
    
    private func updateReminder() {
        
        reminder.title = title
        reminder.note = note.isEmpty ? nil : note
        reminder.reminderDate = showCalendar ? reminderDate : nil
        reminder.reminderTime = showTime ? reminderTime : nil
         
        NotificationManager.scheduleNotification(userData: UserData(title: reminder.title, body: reminder.note, date: reminder.reminderDate, time: reminder.reminderTime))
    }
    
    var body: some View {
        Form {
            Section {
                TextField("Title", text: $title)
                TextField("Note", text: $note)
            }
            
            Section {
                HStack {
                    Image(systemName: "calendar")
                        .foregroundStyle(.red)
                        .font(.title2) 
                    
                    Spacer()
                    
                    Toggle(isOn: $showCalendar) {
                        EmptyView()
                    }
                }
                
                if showCalendar {
                    DatePicker("Select date", selection: $reminderDate, in: .now... ,displayedComponents: .date)
                }
                
                HStack {
                    Image(systemName: "clock")
                        .foregroundStyle(.blue)
                        .font(.title2)
                    
                    Spacer()
                    
                    Toggle(isOn: $showTime) {
                        EmptyView()
                    }
                }
                .onChange(of: showTime, {
                    if showTime {
                        showCalendar = true
                    }
                })
                
                
                if showTime {
                    DatePicker("Select time", selection: $reminderTime, displayedComponents: .hourAndMinute)
                }
                
                
            }
        }
        .onAppear {
            title = reminder.title
            note = reminder.note ?? ""
            reminderDate = reminder.reminderDate ?? Date()
            reminderTime = reminder.reminderTime ?? Date()
            showCalendar = reminder.reminderDate != nil
            showTime = reminder.reminderTime != nil
        }
        .navigationTitle("Detail")
        .toolbar(content: {
            ToolbarItem(placement: .topBarLeading, content: {
                Button("Close", action: {
                    dismiss()
                })
            })
            ToolbarItem(placement: .topBarTrailing, content: {
                Button("Done", action: {
                    updateReminder()
                    dismiss()
                })
                .disabled(!isFormValid)
            })
        })
    }
}

struct ReminderEditScreenContainer: View {
    
    @Query(sort: \Reminder.title) private var reminders: [Reminder]
    
    var body: some View {
        ReminderEditScreen(reminder: reminders[0])

    }
}
#Preview { @MainActor in
    NavigationStack {
        ReminderEditScreenContainer()
            .modelContainer(previewContainer)
    }
    
        
}
