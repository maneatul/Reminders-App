//
//  Reminder.swift
//  RemindersApp
//
//  Created by Atul Mane on 23/08/24.
//

import Foundation
import SwiftData

@Model
class Reminder {
    var title: String
    var note: String?
    var isCompleted: Bool
    var reminderDate: Date?
    var reminderTime: Date?
    
    var myList: Item?
    
    init(title: String, note: String? = nil, isCompleted: Bool = false, reminderDate: Date? = nil, reminderTime: Date? = nil, myList: Item? = nil) {
        self.title = title
        self.note = note
        self.isCompleted = isCompleted
        self.reminderDate = reminderDate
        self.reminderTime = reminderTime
        self.myList = myList
    }
}
