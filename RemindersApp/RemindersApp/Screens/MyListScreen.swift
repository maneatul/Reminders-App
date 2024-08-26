//
//  MyListScreen.swift
//  RemindersApp
//
//  Created by Atul Mane on 23/08/24.
//

import SwiftUI
import SwiftData

enum ReminderStatsType: Int, Identifiable {
    case today
    case scheduled
    case all
    case completed
    
    var id: Int {
        self.rawValue
    }
    
    var title: String {
        switch self {
        case .all : return "All"
        case .today: return "Today"
        case .scheduled: return "Scheduled"
        case .completed: return "Completed"
        }
    }
    
}

struct MyListScreen: View {
    
    @Environment(\.modelContext) private var context
    @Query private var myLists: [Item]
    @Query private var reminders: [Reminder]
    
    @State private var isPresented: Bool = false
    
    @State private var selectedItem: Item?
    
    @State private var search: String = ""
    
    @State private var actionSheet: MyListScreenSheet?
    @State private var reminderStatsType: ReminderStatsType?
    
    @Environment(\.colorScheme) private var colorScheme
    enum MyListScreenSheet: Identifiable {
        
        case newList
        case editList(Item)
        
        var id: Int {
            switch self {
            case .newList:
                return 1
            case .editList(let list):
                return list.hashValue
            }
        }
    }
    
    private var allInCompleted: [Reminder] {
        reminders.filter { !$0.isCompleted }
    }
    
    private var todaysReminders: [Reminder] {
        reminders.filter {
            guard let reminderDate = $0.reminderDate else { return false }
            return reminderDate.isToday && !$0.isCompleted
        }
    }
    
    private var scheduledReminders: [Reminder] {
        reminders.filter {
            $0.reminderDate != nil && !$0.isCompleted
        }
    }
    
    private var completedReminders: [Reminder] {
        reminders.filter { $0.isCompleted }
    }
    
    private var searchResults: [Reminder] {
        reminders.filter {
            $0.title.lowercased().contains(search.lowercased()) && !$0.isCompleted
        }
    }
    
    private func reminders(for type: ReminderStatsType) -> [Reminder] {
        switch type {
        case .all: return allInCompleted
        case .scheduled: return scheduledReminders
        case .today: return todaysReminders
        case .completed: return completedReminders
        }
    }
    
    private func deleteListItem(indexSet: IndexSet) {
        
        guard let index = indexSet.first else { return }
        let myList = myLists[index]
        
        context.delete(myList)
    }
    var body: some View {
        
        List {
          
            VStack {
                HStack {
                    ReminderStatsView(icon: "calendar", title: "Today", count: todaysReminders.count)
                        .onTapGesture {
                            reminderStatsType = .today
                        }
                    ReminderStatsView(icon: "calendar.circle.fill", title: "Scheduled", count: scheduledReminders.count)
                        .onTapGesture {
                            reminderStatsType = .scheduled
                        }
                }
                HStack {
                    ReminderStatsView(icon: "tray.circle.fill", title: "All", count: allInCompleted.count)
                        .onTapGesture {
                            reminderStatsType = .all
                        }
                    ReminderStatsView(icon: "checkmark.circle.fill", title: "Completed", count: completedReminders.count)
                        .onTapGesture {
                            reminderStatsType = .completed
                        }
                }
            }
            
            ForEach(myLists) { item in
                
                NavigationLink(value: item, label: {
                    
                    MyListCellView(item: item)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedItem = item
                        }
                        .onLongPressGesture(minimumDuration: 0.5, perform: {
                            actionSheet = .editList(item)

                        })
                })
            }
            .onDelete(perform: deleteListItem)
            
            Button(action: {
                actionSheet = .newList
            }, label: {
                Text("Add List")
                    .foregroundStyle(.blue)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            })
            .listRowSeparator(.hidden)
        }
        .searchable(text: $search)
        .overlay {
            if !search.isEmpty {
                ReminderListView(reminders: searchResults)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(colorScheme == .dark ? .black: .white)
            }
        }
        .navigationTitle("My List")
        .navigationDestination(item: $selectedItem, destination: { item in
            MyListDetailsScreen(myItem: item)
        })
        .navigationDestination(item: $reminderStatsType, destination: { type in
            NavigationStack {
                ReminderListView(reminders: reminders(for: type))
                    .navigationTitle(type.title)
            }
        })
        .listStyle(.plain)
        .sheet(item: $actionSheet, content: { actionSheet in
        
            switch actionSheet {
                
            case .newList:
                NavigationStack {
                    AddMyListItemScreen()
                }
                
            case .editList(let item):
                NavigationStack {
                    AddMyListItemScreen(myItem: item)
                }
                
            }
        })
//        .sheet(isPresented: $isPresented, content: {
//            NavigationStack {
//                AddMyListItemScreen()
//            }
//        })
    }
    
}

#Preview { @MainActor in
    NavigationStack {
        MyListScreen()
    }
    .modelContainer(previewContainer)
}
