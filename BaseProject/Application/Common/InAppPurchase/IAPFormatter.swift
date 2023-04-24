//
//  IAPFormatter.swift
//  BaseProject
//
//  Created by Tam Le on 7/28/20.
//  Copyright © 2020 Tam Le. All rights reserved.
//

import Foundation

class IAPFormatter {
    
    static let shared = IAPFormatter()
    
    private init() {}
    
    let priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        
        formatter.formatterBehavior = .behavior10_4
        formatter.numberStyle = .currency
        
        return formatter
    }()
    
    func getStringFromDate(date: Date, format: String) -> String         // convert date to string
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let stringdate = dateFormatter.string(from: date)
        return stringdate
    }
    
    func getDatefromString(strdate: String, format: String) -> Date      // convert string to date
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        if dateFormatter.date(from: strdate) != nil {
            let datevalue = dateFormatter.date(from: strdate)
            return datevalue!
        } else {
            // invalid format
            return Date()
        }
    }
    
}
