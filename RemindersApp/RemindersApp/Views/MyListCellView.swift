//
//  MyListCellView.swift
//  RemindersApp
//
//  Created by Atul Mane on 24/08/24.
//

import SwiftUI

struct MyListCellView: View {
    
    let item: Item
    
    var body: some View {
        HStack {
            Image(systemName: "line.3.horizontal.circle.fill")
                .font(.system(size: 32))
                .foregroundStyle(Color(hex: item.colorCode))
            Text(item.name)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
