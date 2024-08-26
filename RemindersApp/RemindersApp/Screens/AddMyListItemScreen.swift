//
//  AddMyListItemScreen.swift
//  RemindersApp
//
//  Created by Atul Mane on 23/08/24.
//

import SwiftUI

struct AddMyListItemScreen: View {
    
    @State private var color: Color = .blue
    @State private var itemName: String = ""
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    var myItem: Item? = nil
    
    var body: some View {
        VStack {
            Image(systemName: "line.3.horizontal.circle.fill")
                .font(.system(size: 80))
                .foregroundStyle(color)
            
            TextField("Item Name", text: $itemName)
                .textFieldStyle(.roundedBorder)
                .padding([.leading, .trailing], 40)
            
            ColorPickerView(selectedColor: $color)
        }
        .onAppear {
            if let myItem {
                itemName = myItem.name
                color = Color(hex: myItem.colorCode)
            }
        }
        .navigationTitle("New Item")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(content: {
            ToolbarItem(placement: .topBarLeading) {
                Button("Close", action: {
                    dismiss()
                })
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button("Done", action: {
                    
                    if let myItem {
                        myItem.name = itemName
                        myItem.colorCode = color.toHex() ?? ""
                        
                    } else {
                        guard let colorHex = color.toHex() else { return }
                        let myItem = Item(name: itemName, colorCode: colorHex)
                        context.insert(myItem)
                    }
                    dismiss()
                })
            }
        })
    }
}

#Preview { @MainActor in
    
    NavigationStack {
        AddMyListItemScreen()
    }
    .modelContainer(previewContainer)
}
