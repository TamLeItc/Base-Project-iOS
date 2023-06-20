//
//  Localize.swift
//  BaseProject
//
//  Created by Tam Le on 20/06/2023.
//

import UIKit

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}

@IBDesignable extension UILabel {
    @IBInspectable var localizeKey: String? {
        set {
            text = newValue?.localized
        }
        get {
            return self.localizeKey
        }
    }
}

@IBDesignable extension UIButton {
    @IBInspectable var localizeKey: String? {
        set {
            setTitle(newValue?.localized, for: .application)
            setTitle(newValue?.localized, for: .normal)
            setTitle(newValue?.localized, for: .focused)
            setTitle(newValue?.localized, for: .highlighted)
            setTitle(newValue?.localized, for: .selected)
            setTitle(newValue?.localized, for: .reserved)
        }
        get {
            return self.localizeKey
        }
    }
}

@IBDesignable extension UITextView {
    @IBInspectable var localizeKey: String? {
        set {
            text = newValue?.localized
        }
        get {
            return self.localizeKey
        }
    }
}
