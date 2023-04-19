//
//  DemoCell.swift
//  BaseProject
//
//  Created by Tam Le on 8/23/20.
//  Copyright © 2020 Tam Le. All rights reserved.
//

import UIKit

class DemoCell: BaseTableViewCell {
    
    @IBOutlet weak var label: UILabel!

    override func setup() {
        
    }
    
    func configureCell(_ item: Post) {
        label.text = item.title
    }
    
}
