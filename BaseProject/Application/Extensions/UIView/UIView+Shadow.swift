//
//  UIView+Shadow.swift
//  BaseProject
//
//  Created by Tam Le on 31/12/2020.
//  Copyright © 2020 Tam Le. All rights reserved.
//

import UIKit

extension UIView {
    
    func addshadow(left: Bool = false,
                   top: Bool = false,
                   right: Bool = false,
                   bottom: Bool = false,
                   height: CGFloat = 4,
                   radius: CGFloat = 0,                 //Shadow corner radius
                   color: UIColor = UIColor.black) {
        
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = 1
        self.layer.shadowColor = color.cgColor
        
        let path = UIBezierPath()
        var x: CGFloat = 0
        var y: CGFloat = 0
        var viewWidth = self.frame.width
        var viewHeight = self.frame.height
        
        // here x, y, viewWidth, and viewHeight can be changed in
        // order to play around with the shadow paths.
        if (!top) {
            y += height
        } else {
            y -= 2
        }
        if (!bottom) {
            viewHeight -= height
        } else {
            viewHeight += 2
        }
        if (!left) {
            x += height
        } else {
            x -= 2
        }
        if (!right) {
            viewWidth -= height
        } else {
            viewWidth += 2
        }
        // selecting top most point
        path.move(to: CGPoint(x: x, y: y))
        // Move to the Bottom Left Corner, this will cover left edges
        /*
         |☐
         */
        path.addLine(to: CGPoint(x: x, y: viewHeight))
        // Move to the Bottom Right Corner, this will cover bottom edge
        /*
         ☐
         -
         */
        path.addLine(to: CGPoint(x: viewWidth, y: viewHeight))
        // Move to the Top Right Corner, this will cover right edge
        /*
         ☐|
         */
        path.addLine(to: CGPoint(x: viewWidth, y: y))
        // Move back to the initial point, this will cover the top edge
        /*
         _
         ☐
         */
        path.close()
        self.layer.shadowPath = path.cgPath
    }
    
    func addDropShadow(
            shadowRadius: CGFloat = 0,
            offset: CGSize = CGSize(width: 0, height: 0),
            color: UIColor = UIColor.black
        ) {
            layer.masksToBounds = false
            layer.shadowColor = color.cgColor
            layer.shadowOffset = offset
            layer.shadowOpacity = 1
            layer.shadowRadius = shadowRadius
        }
        
        func addInnerShadow(
            shadowRadius: CGFloat = 0,
            offset: CGSize = CGSize(width: 0, height: 0),
            color: UIColor = UIColor.black
        ) {
            let innerShadow = CALayer()
            innerShadow.frame = bounds
            
            // Shadow path (1pt ring around bounds)
            let radius = self.layer.cornerRadius
            let path = UIBezierPath(roundedRect: innerShadow.bounds.insetBy(dx: 2, dy:2), cornerRadius:radius)
            let cutout = UIBezierPath(roundedRect: innerShadow.bounds, cornerRadius:radius).reversing()
            
            path.append(cutout)
            innerShadow.shadowPath = path.cgPath
            innerShadow.masksToBounds = true
            
            // Shadow properties
            innerShadow.shadowColor = color.cgColor
            innerShadow.shadowOffset = offset
            innerShadow.shadowOpacity = 1
            innerShadow.shadowRadius = shadowRadius
            innerShadow.cornerRadius = self.layer.cornerRadius
            layer.addSublayer(innerShadow)
        }

}
