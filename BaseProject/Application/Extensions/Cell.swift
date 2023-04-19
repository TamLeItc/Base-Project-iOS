//
//  Cell.swift
//  BaseProject
//
//  Created by Tam Le on 06/04/2022.
//  Copyright © 2022 Tam Le. All rights reserved.
//

import UIKit

@IBDesignable extension UITableViewCell {
    
    class var identifier: String { return String.className(self) }
    
    @IBInspectable var selectedColor: UIColor? {
        set {
            let colorView = UIView()
            colorView.backgroundColor = newValue
            self.selectedBackgroundView = colorView
        }
        get {
            return self.selectedBackgroundView?.backgroundColor
        }
    }
    
    open func hideKeyboard() {
        contentView.endEditing(true)
    }
}

extension UICollectionViewCell {
    
    class var identifier: String { return String.className(self) }
    
    @IBInspectable var selectedColor: UIColor? {
        set {
            let colorView = UIView()
            colorView.backgroundColor = newValue
            self.selectedBackgroundView = colorView
        }
        get {
            return self.selectedBackgroundView?.backgroundColor
        }
    }
    
    open func hideKeyboard() {
        contentView.endEditing(true)
    }
}
