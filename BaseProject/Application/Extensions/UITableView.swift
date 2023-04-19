//
//  UITableView.swift
//  BaseProject
//
//  Created by Tam Le on 7/28/20.
//  Copyright © 2020 Tam Le. All rights reserved.
//

import Foundation
import UIKit
import Localize

public extension UITableView {
    
    func registerCellClass(_ cellClass: AnyClass) {
        let identifier = String.className(cellClass)
        self.register(cellClass, forCellReuseIdentifier: identifier)
    }
    
    func registerCellNib(_ cellClass: AnyClass) {
        let identifier = String.className(cellClass)
        let nib = UINib(nibName: identifier, bundle: nil)
        self.register(nib, forCellReuseIdentifier: identifier)
    }
    
    func registerHeaderFooterViewClass(_ viewClass: AnyClass) {
        let identifier = String.className(viewClass)
        self.register(viewClass, forHeaderFooterViewReuseIdentifier: identifier)
    }
    
    func registerHeaderFooterViewNib(_ viewClass: AnyClass) {
        let identifier = String.className(viewClass)
        let nib = UINib(nibName: identifier, bundle: nil)
        self.register(nib, forHeaderFooterViewReuseIdentifier: identifier)
    }
    
    func dequeueReuseable<T:BaseTableViewCell>(ofType type: T.Type, indexPath: IndexPath) -> T {
        guard let cell = self.dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as? T else {
            fatalError("Couldn't find UITableViewCell of class \(type.identifier)")
        }
        return cell
    }
    
    func applyChanges(deletions: [Int], insertions: [Int], updates: [Int], section: Int) {
        if #available(iOS 11.0, *) {
            performBatchUpdates({
                deleteRows(at: deletions.map { IndexPath(row: $0, section: section) }, with: .fade)
                insertRows(at: insertions.map { IndexPath(row: $0, section: section) }, with: .fade)
                reloadRows(at: updates.map { IndexPath(row: $0, section: section) }, with: .fade)
            })
        } else {
            beginUpdates()
            deleteRows(at: deletions.map { IndexPath(row: $0, section: section) }, with: .automatic)
            insertRows(at: insertions.map { IndexPath(row: $0, section: section) }, with: .automatic)
            reloadRows(at: updates.map { IndexPath(row: $0, section: section) }, with: .automatic)
            endUpdates()
        }
    }
    
    func scrollToFirstItem(animated: Bool = false) {
        tryBlock {
            self.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: animated)
        }
    }
}

extension UITableView {
    func setEmptyMessage(_ message: String = "no_items_to_show".localized) {
        let messageLabel = UILabel(frame: bounds)
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = Theme.Fonts.regular.with(16)
        messageLabel.sizeToFit()
        
        backgroundView = messageLabel
    }
    
    func hideEmptyMessage() {
        backgroundView = nil
    }
}
