//
//  UITextField.swift
//  BaseProject
//
//  Created by Tam Le on 10/07/2021.
//  Copyright © 2021 Tam Le. All rights reserved.
//

import UIKit

extension UITextField {
    func setLeftIcon(_ image: UIImage) {
        let iconView = UIImageView(frame: CGRect(x: 10, y: 5, width: 16, height: 16))
        iconView.image = image
        let iconContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        iconContainerView.addSubview(iconView)
        NSLayoutConstraint.activate([
            iconView.centerYAnchor.constraint(equalTo: iconContainerView.centerYAnchor),
            iconView.centerXAnchor.constraint(equalTo: iconContainerView.centerXAnchor)
        ])
        leftView = iconContainerView
        leftViewMode = .always
    }
    
    func setRightIcon(_ image: UIImage) {
        let iconView = UIImageView(frame: CGRect(x: 10, y: 5, width: 16, height: 16))
        iconView.image = image
        let iconContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        iconContainerView.addSubview(iconView)
        NSLayoutConstraint.activate([
            iconView.centerYAnchor.constraint(equalTo: iconContainerView.centerYAnchor),
            iconView.centerXAnchor.constraint(equalTo: iconContainerView.centerXAnchor)
        ])
        rightView = iconContainerView
        rightViewMode = .always
    }
}
