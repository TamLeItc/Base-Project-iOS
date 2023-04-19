//
//  UICollectionView.swift
//  BaseProject
//
//  Created by Tam Le on 10/16/20.
//  Copyright © 2020 Tam Le. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    func registerCellClass(_ cellClass: AnyClass) {
        let identifier = String.className(cellClass)
        self.register(cellClass, forCellWithReuseIdentifier: identifier)
    }
    
    func registerCellNib(_ cellClass: AnyClass) {
        let identifier = String.className(cellClass)
        let nib = UINib(nibName: identifier, bundle: nil)
        self.register(nib, forCellWithReuseIdentifier: identifier)
    }
    
    func registerHeaderFooterViewClass(_ viewClass: AnyClass) {
        let identifier = String.className(viewClass)
        self.register(viewClass, forCellWithReuseIdentifier: identifier)
    }
    
    func registerHeaderFooterViewNib(_ viewClass: AnyClass) {
        let identifier = String.className(viewClass)
        let nib = UINib(nibName: identifier, bundle: nil)
        self.register(nib, forCellWithReuseIdentifier: identifier)
    }
    
    func dequeueReuseable<T:BaseCollectionViewCell>(ofType type: T.Type, indexPath: IndexPath) -> T {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as? T else {
            fatalError("Couldn't find UICollectionView of class \(type.identifier)")
        }
        return cell
    }
    
    func applyChanges(deletions: [Int], insertions: [Int], updates: [Int], section: Int) {
        performBatchUpdates({
            deleteItems(at: deletions.map{
                IndexPath(row: $0, section: section)
            })
            insertItems(at: insertions.map{
                IndexPath(row: $0, section: section)
            })
            reloadItems(at: updates.map{
                IndexPath(row: $0, section: section)
            })
        })
    }
    
    func scrollToFirstItem(animated: Bool = false) {
        tryBlock {
            self.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: animated)
        }
    }
    
    func scrollToLastItem(animated: Bool = false) {
        tryBlock {
            self.scrollToItem(at: IndexPath(item: self.dataSource?.collectionView(self, numberOfItemsInSection: 0) ?? 0, section: 0), at: .top, animated: animated)
        }
    }
}

extension UICollectionView {
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
