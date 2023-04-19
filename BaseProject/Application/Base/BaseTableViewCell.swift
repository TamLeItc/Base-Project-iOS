//
//  BaseTableViewCell.swift
//  BaseProject
//
//  Created by Tam Le on 7/28/20.
//  Copyright © 2020 Tam Le. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

open class BaseTableViewCell : UITableViewCell {
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    open override func awakeFromNib() {
        setup()
    }
    
    // ignore the default handling
    override open func setSelected(_ selected: Bool, animated: Bool) {
    }
    
    func setup() {
    }
  
}
