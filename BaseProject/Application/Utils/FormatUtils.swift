//
//  FormatUtils.swift
//  BaseProject
//
//  Created by Tam Le on 20/09/2022.
//  Copyright © 2022 Tam Le. All rights reserved.
//

import Foundation

class FormatUtils {
    
    static func formatDateToString(_ date: Date, formatterString: String = "dd MMM yyyy HH:mm") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = formatterString
        return formatter.string(from: date)
    }
    
    static func formatStringToDate(_ text: String, formatterString: String = "dd MMM yyyy HH:mm") -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = formatterString
        return formatter.date(from: text) ?? Date()
    }
    
}
