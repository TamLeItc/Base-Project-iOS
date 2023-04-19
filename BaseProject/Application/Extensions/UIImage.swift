//
//  UIImage.swift
//  BaseProject
//
//  Created by Tam Le on 22/11/2020.
//  Copyright © 2020 Tam Le. All rights reserved.
//

import UIKit

enum BlurStyle: String {
    case ciBoxBlur = "CIBoxBlur"
    case ciDiscBlur = "CIDiscBlur"
    case ciGaussianBlur = "CIGaussianBlur"
    case ciMotionBlur = "CIMotionBlur"
}

extension UIImage {
    
    /**
     https://developer.apple.com/library/archive/documentation/GraphicsImaging/Reference/CoreImageFilterReference/
     ciFilterName value:
     CIBoxBlur
     CIDiscBlur
     CIGaussianBlur
     CIMedianFilter
     */
    func asBlurImage(ciFilterName: BlurStyle = .ciGaussianBlur, radius: CGFloat = 10) -> UIImage? {
        let context = CIContext(options: nil)
        let inputImage = CIImage(image: self)
        let originalOrientation = self.imageOrientation
        let originalScale = self.scale
        
        let filter = CIFilter(name: ciFilterName.rawValue)
        filter?.setValue(inputImage, forKey: kCIInputImageKey)
        filter?.setValue(radius, forKey: kCIInputRadiusKey)
        let outputImage = filter?.outputImage
        
        var cgImage:CGImage?
        
        if let asd = outputImage
        {
            cgImage = context.createCGImage(asd, from: (inputImage?.extent)!)
        }
        
        if let cgImageA = cgImage
        {
            return UIImage(cgImage: cgImageA, scale: originalScale, orientation: originalOrientation)
        }
        
        return nil
    }
    
    public func withRoundedCorners(radius: CGFloat? = nil) -> UIImage? {
        let maxRadius = min(size.width, size.height) / 2
        let cornerRadius: CGFloat
        if let radius = radius, radius > 0 && radius <= maxRadius {
            cornerRadius = radius
        } else {
            cornerRadius = maxRadius
        }
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let rect = CGRect(origin: .zero, size: size)
        UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).addClip()
        draw(in: rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
