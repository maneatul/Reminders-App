//
//  String+Extension.swift
//  RemindersApp
//
//  Created by Atul Mane on 23/08/24.
//

import Foundation

extension String {
    var isEmptyOrWhitespaces: Bool {
        trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
