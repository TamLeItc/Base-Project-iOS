//
//  BaseCollectionViewCell.swift
//  BaseProject
//
//  Created by Tam Le on 8/19/20.
//  Copyright © 2020 Tam Le. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class BaseCollectionViewCell: UICollectionViewCell {
    
    let bag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
        setupEventViews()
    }
    
    func setup() {}
    
    func setupEventViews() { }
}
