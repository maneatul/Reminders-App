//
//  Colors+Extension.swift
//  RemindersApp
//
//  Created by Atul Mane on 23/08/24.
//

import Foundation
import SwiftUI

extension Color {
    
    func toHex() -> String? {
        let uiColor = UIColor(self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        let r = Int(red * 255)
        let g = Int(green * 255)
        let b = Int(blue * 255)
        
        // If you want to include alpha in the hex string
        let a = Int(alpha * 255)
        
        if alpha == 1.0 {
            // Return hex string without alpha
            return String(format: "#%02X%02X%02X", r, g, b)
        } else {
            // Return hex string with alpha
            return String(format: "#%02X%02X%02X%02X", r, g, b, a)
        }
    }
    
    
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "#", with: "")
        let scanner = Scanner(string: hex)
        var hexNumber: UInt64 = 0

        if scanner.scanHexInt64(&hexNumber) {
            let r, g, b, a: Double
            let length = hex.count

            if length == 6 {
                r = Double((hexNumber & 0xFF0000) >> 16) / 255
                g = Double((hexNumber & 0x00FF00) >> 8) / 255
                b = Double(hexNumber & 0x0000FF) / 255
                a = 1.0
            } else if length == 8 {
                r = Double((hexNumber & 0xFF000000) >> 24) / 255
                g = Double((hexNumber & 0x00FF0000) >> 16) / 255
                b = Double((hexNumber & 0x0000FF00) >> 8) / 255
                a = Double(hexNumber & 0x000000FF) / 255
            } else {
                r = 1.0
                g = 1.0
                b = 1.0
                a = 0.0
            }

            self.init(.sRGB, red: r, green: g, blue: b, opacity: a)
            return
        }

        self.init(.sRGB, red: 1.0, green: 1.0, blue: 1.0, opacity: 0.0) // Default to transparent if hex is invalid
    }
}
