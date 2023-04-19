//
//  UIView.swift
//  BaseProject
//
//  Created by Tam Le on 08/01/2021.
//  Copyright © 2021 Tam Le. All rights reserved.
//

import UIKit

extension UIView {
    
    func removeAllSubviews() {
        subviews.forEach({subview in
            subview.removeFromSuperview()
        })
    }
    
    func createBlurEffect(style: UIBlurEffect.Style,
                          backgroundColor: UIColor = UIColor(hex: 0xffffff, alpha: 0.2),
                          cornerRadius: CGFloat = 0) -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.backgroundColor = backgroundColor
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.cornerRadius = cornerRadius
        return blurEffectView
    }
    
    func asImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0.0)
        self.drawHierarchy(in: self.bounds, afterScreenUpdates: false)
        let snapshotImageFromMyView = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snapshotImageFromMyView!
    }
    
}
