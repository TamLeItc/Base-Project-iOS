//
//  String+Convert.swift
//  BaseProject
//
//  Created by Tam Le on 7/28/20.
//  Copyright © 2020 Tam Le. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

extension String {
    
    func toUIImage(renderingMode: UIImage.RenderingMode = .alwaysOriginal) -> UIImage? {
            return UIImage(named: self)?.withRenderingMode(renderingMode)
        }
    
    var toUIColor: UIColor {
        if let color = UIColor(named: self) {
            return color
        } else {
            var hexWithoutSymbol: String = self
            if hexWithoutSymbol.hasPrefix("#") {
                hexWithoutSymbol = substring(from: 1)
            }
            
            let scanner = Scanner(string: hexWithoutSymbol)
            var hexInt : UInt64 = 0
            scanner.scanHexInt64(&hexInt)
            
            return UIColor(red: CGFloat((hexInt & 0xFF0000) >> 16) / 255.0,
                           green: CGFloat((hexInt & 0x00FF00) >> 8) / 255.0,
                           blue: CGFloat(hexInt & 0x0000FF) / 255.0,
                           alpha: 1)
        }
    }
    
    
    @available(iOS 13.0, *)
    var toColor: Color {
        let hex = self.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        return Color.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    var toUInt32: UInt32 {
        if let char = UnicodeScalar(self) {
            return char.value
        } else {
            return 0
        }
    }
    
    var toInt: Int? {
        return Int(self)
    }
    
    var toFloat: Float? {
        return Float(self)
    }
    
    var toDouble: Double? {
        return Double(self)
    }
    
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
