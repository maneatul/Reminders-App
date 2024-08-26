//
//  ReminderCellView.swift
//  RemindersApp
//
//  Created by Atul Mane on 23/08/24.
//

import SwiftUI
import SwiftData

enum ReminderCellEvents {
    case onCheck(Reminder, Bool)
    case onSelected(Reminder)
}


struct ReminderCellView: View {
    
    let reminder: Reminder
//    let isSelected: Bool
    let onEvent: (ReminderCellEvents) -> Void
    
    @State private var checked: Bool = false
        
    private func formatReminderDate(_ date: Date) -> String {
        if date.isToday {
            return "Today"
        } else if date.isTomorrow {
            return "Tomorrow"
        } else {
            return date.formatted(date: .numeric, time: .omitted)
        }
    }
    
    var body: some View {
        HStack(alignment: .top) {
            
            Image(systemName: checked ? "circle.inset.filled" :"circle")
                .font(.title2)
                .padding([.trailing], 5)
                .onTapGesture {
                    checked.toggle()
                    onEvent(.onCheck(reminder, checked))  
                }
            
            VStack {
                Text(reminder.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                if let note = reminder.note {
                    Text(note)
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                HStack {
                    if let reminderDate = reminder.reminderDate {
                        Text(formatReminderDate(reminderDate))
                    }
                    if let reminderTime = reminder.reminderTime {
                        Text(reminderTime, style: .time)
                    }
                }
                .font(.caption)
                .foregroundStyle(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
                
            }
            Spacer()
//            Image(systemName: "info.circle.fill")
//                .opacity(isSelected ? 1 : 0)
//                .onTapGesture {
//                    onEvent(.onInfoSelected(reminder))
//                }
        }
        .onAppear {
            checked = reminder.isCompleted
        }
        .contentShape(Rectangle())
        .onTapGesture {
            onEvent(.onSelected(reminder))
        }
    }
}




struct ReminderCellViewContainer: View {
    
    @Query(sort: \Reminder.title) private var reminders: [Reminder]
    
    var body: some View {
        ReminderCellView(reminder: reminders[0]) { _ in
            
        }

    }
}
#Preview { @MainActor in
    
    ReminderCellViewContainer()
        .modelContainer(previewContainer)
        
}
