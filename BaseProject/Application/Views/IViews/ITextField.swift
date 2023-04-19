//
//  ITextField.swift
//  BaseProject
//
//  Created by Tam Le on 7/29/20.
//  Copyright © 2020 Tam Le. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class ITextField: UITextField {
    
    @IBInspectable var paddingLeft: CGFloat = 6
    @IBInspectable var paddingRight: CGFloat = 6
    
    @IBInspectable var inputAccessoryViewHeightPhone: CGFloat = 40
    @IBInspectable var inputAccessoryViewHeightPad: CGFloat = 60

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + paddingLeft, y: bounds.origin.y,
                      width: bounds.size.width - paddingLeft - paddingRight, height: bounds.size.height);
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        initViews()
    }
    
    private func initViews() {
        initPlaceholder()
    }
    
    private func initPlaceholder() {
        placeholder = localizePlaceholder
        attributedPlaceholder = NSAttributedString(
            string: localizePlaceholder ?? "",
            attributes: [
                NSAttributedString.Key.foregroundColor: Theme.Colors.textPrimary,
                NSAttributedString.Key.font: Theme.Fonts.regular.with(15) as Any
            ]
        )
    }
    
    private func setupInputAccessoryView() {
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        
        var inputAccessoryViewHeight = inputAccessoryViewHeightPhone
        if UIDevice().userInterfaceIdiom == .pad {
            inputAccessoryViewHeight = inputAccessoryViewHeightPad
        }
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: inputAccessoryViewHeight))
        customView.backgroundColor = UIColor(named: "inputAccessoryColor")
        self.inputAccessoryView = customView
        
        let doneButton = UIButton()
        doneButton.setTitle("Done", for: .normal)
        customView.addSubview(doneButton)
        
        doneButton.addTarget(self, action: #selector(doneButtonTouchUp(_:)), for: .touchUpInside)
        
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.centerYAnchor.constraint(equalTo: customView.centerYAnchor).isActive = true
        doneButton.topAnchor.constraint(equalTo: customView.topAnchor).isActive = true
        doneButton.bottomAnchor.constraint(equalTo: customView.bottomAnchor).isActive = true
        doneButton.trailingAnchor.constraint(equalTo: customView.trailingAnchor, constant: -16).isActive = true
    }
    
    @objc func doneButtonTouchUp(_ sender: Any) {
        self.resignFirstResponder()
    }
}
