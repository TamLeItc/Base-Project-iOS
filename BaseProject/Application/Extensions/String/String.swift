//
//  String.swift
//  BaseProject
//
//  Created by Tam Le on 7/28/20.
//  Copyright © 2020 Tam Le. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    init<S: Sequence>(unicodeScalars ucs: S)
    where S.Iterator.Element == UnicodeScalar
    {
        var s = ""
        s.unicodeScalars.append(contentsOf: ucs)
        self = s
    }
    
    subscript(_ range: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: max(0, range.lowerBound))
        let end = index(start, offsetBy: min(self.count - range.lowerBound,
                                             range.upperBound - range.lowerBound))
        return String(self[start..<end])
    }
    
    static func className(_ aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last!
    }
    
    func substring(from : Int) -> String {
        let fromIndex = self.index(self.startIndex, offsetBy: from)
        return String(self[fromIndex...])
    }
    
    func substring(to: String) -> String {
        if let range = self.range(of: to, options: .backwards) {
            return String(self[...range.lowerBound])
        } else {
            return ""
        }
    }
    
    var length: Int {
        return self.count
    }
    
    var isNotEmpty: Bool {
        return !isEmpty
    }
    
    //Remove all space, new line and tab at start and end string
    //Remove app space if dulicate space in string
    var trim: String{
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    //Remove all space, new line and tab in string
    var trimAll: String{
        return String(self.filter { !" \n\t\r".contains($0) })
    }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    var isBlank: Bool {
        return self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
    
        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return ceil(boundingBox.width)
    }
}
