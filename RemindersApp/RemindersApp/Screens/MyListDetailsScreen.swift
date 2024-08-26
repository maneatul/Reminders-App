//
//  MyListDetailsScreen.swift
//  RemindersApp
//
//  Created by Atul Mane on 23/08/24.
//

import SwiftUI
import SwiftData

struct MyListDetailsScreen: View {
    
    var myItem: Item
    
    @State private var title: String = ""
    @State private var isNewReminderPresent: Bool = false
    @State private var showReminderEditScreen: Bool = false
    @State private var selectedReminder: Reminder?
    
    @Environment(\.modelContext) private var context
    
    private var isFormValid: Bool {
        !title.isEmpty
    }
    
    private func saveReminder() {
        let reminder = Reminder(title: title)
        myItem.reminders.append(reminder)
    }
    
    private func isReminderSelected(_ reminder: Reminder) -> Bool {
        reminder.persistentModelID == selectedReminder?.persistentModelID
    }
    
    private func deleteReminder(_ indexSet: IndexSet) {
        
        guard let index = indexSet.last else { return }
        let reminder = myItem.reminders[index]
        context.delete(reminder)
    }
    
    var body: some View {
        
        VStack {
            
            ReminderListView(reminders: myItem.reminders.filter { !$0.isCompleted})
            
            Spacer()
            
            Button(action: {
                isNewReminderPresent.toggle()
            }, label: {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("New Reminder")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            })
            
        }
        .navigationTitle(myItem.name)
        .alert("New Reminder", isPresented: $isNewReminderPresent, actions: {
            TextField("", text: $title)
            Button("Cancel", role: .cancel, action: {})
            Button("Done", action: {
                saveReminder()
                title = ""
            })
            .disabled(!isFormValid)
        })
//        .sheet(isPresented: $showReminderEditScreen, content: {
//            if let selectedReminder = selectedReminder {
//                NavigationStack {
//                    ReminderEditScreen(reminder: selectedReminder)
//                }
//            }
//        })
        
        
    }
}


struct MyListDetailsScreenContainer: View {
    
    @Query private var myList: [Item]

    var body: some View {
        MyListDetailsScreen(myItem: myList[0])
    }
}


#Preview { @MainActor in

    NavigationStack {
        MyListDetailsScreenContainer()
    }
    .modelContainer(previewContainer)
}
