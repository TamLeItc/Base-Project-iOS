//
//  IntrinsicTableView.swift
//  BaseProject
//
//  Created by Tam Le on 15/07/2021.
//  Copyright © 2021 Tam Le. All rights reserved.
//

import UIKit

class IntrinsicTableView: UITableView {
    override var contentSize:CGSize {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}
