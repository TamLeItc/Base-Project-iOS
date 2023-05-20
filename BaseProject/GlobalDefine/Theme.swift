//
//  Theme.swift
//  BaseProject
//
//  Created by Tam Le on 20/05/2021.
//  Copyright © 2021 Tam Le. All rights reserved.
//

import UIKit

enum Theme {
    //MARK: -- Color
    enum Colors {
        static let primary = "colorPrimary".toUIColor()
        static let secondary = "colorSecondary".toUIColor()
        static let textPrimary = "colorTextPrimary".toUIColor()
        static let textsecondary = "colorTextSecondary".toUIColor()
        static let accent = "colorAccent".toUIColor()
        
        enum InApp {
            static let primaryColor = UIColor(hex: 0xffffff)
            static let textProductView = UIColor(hex: 0x1F584E)
            static let backgroundProductView: UIColor = .clear
            static let textProductViewSelect = UIColor(hex: 0xffffff)
            static let backgroundProductViewSelect = UIColor(hex: 0xF5A031)
        }
    }
    
    enum Fonts: String {
        case regular = "Overpass-Regular"
        case bold = "Overpass-Bold"
        case extraBold = "Overpass-ExtraBold"
        case semiBold = "Overpass-SemiBold"
        
        func with(_ size: CGFloat) -> UIFont? {
            return UIFont(name: rawValue, size: size)
        }
    }
}
