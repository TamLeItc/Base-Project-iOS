//
//  LoadmoreCell.swift
//  BaseProject
//
//  Created by Tam Le on 8/23/20.
//  Copyright © 2020 Tam Le. All rights reserved.
//

import UIKit

class LoadmoreCell: BaseTableViewCell {

    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    override func setup() {
        indicatorView.startAnimating()
    }
    
}
