//
//  Item.swift
//  RemindersApp
//
//  Created by Atul Mane on 23/08/24.
//

import SwiftData

@Model
class Item {
    var name: String
    var colorCode: String
    
    @Relationship(deleteRule: .cascade)
    var reminders: [Reminder] = []
    
    init(name: String, colorCode: String) {
        self.name = name
        self.colorCode = colorCode
    }
}
