//
//  AlertConstants.swift
//  BaseProject
//
//  Created by Tam Le on 02/09/2021.
//  Copyright © 2021 Tam Le. All rights reserved.
//

import UIKit

//0xFF8080
enum AlertTheme {
    enum Colors {
        static let backgroundColor: UIColor? = UIColor(hex: 0xF9F9F9)
        static let titleColor: UIColor? = UIColor(hex: 0x1D2937)
        static let messageColor: UIColor? = UIColor(hex: 0x1D2937)
        
        enum Alert {
            static let normalTitleColor: UIColor? = Theme.Colors.primary
            static let normalBorderColor: UIColor? = Theme.Colors.primary
            
            static let destructiveTitleColor: UIColor? = UIColor(hex: 0xFF8080)
            static let destructiveBorderColor: UIColor? = UIColor(hex: 0xFF8080)

            //confirm action
            static let confirmTitleColor: UIColor? = UIColor(hex: 0xffffff)
            static let confirmBgStartColor: UIColor? = Theme.Colors.primary
            static let confirmBgEndColor: UIColor? = Theme.Colors.secondary
        }
        
        enum Sheet {
            static let separatorColor: UIColor? = UIColor(hex: 0x858585)
            
            static let normalTitleColor: UIColor? = UIColor(hex: 0x1D2937)
            static let destructiveTitleColor: UIColor? = UIColor(hex: 0xFF8080)
        }
    }
    
    enum Fonts {
        static let alertTitle: UIFont? = UIFont(name: "Poppins-SemiBold", size: 16)
        static let alertMessage: UIFont? = UIFont(name: "Poppins-Regular", size: 14)
        static let alertAction: UIFont? = UIFont(name: "Poppins-Medium", size: 14)
        static let alertActionCancel: UIFont? = UIFont(name: "Poppins-SemiBold", size: 14)
        
        static let sheetTitle: UIFont? = UIFont(name: "Poppins-SemiBold", size: 12)
        static let sheetMessage: UIFont? = UIFont(name: "Poppins-Regular", size: 16)
        static let sheetAction: UIFont? = UIFont(name: "Poppins-Medium", size: 16)
        static let sheetActionCancel: UIFont? = UIFont(name: "Poppins-SemiBold", size: 16)
    }
    
}

enum AlertStyle {
    case actionSheet
    case alert
}

enum AlertActionStyle {
    case normal
    case confirm
    case cancel
    case destructive
}

enum AlertMessageTyle {
    case warning
    case info
    case error
}
