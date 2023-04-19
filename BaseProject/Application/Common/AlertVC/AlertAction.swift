//
//  AlertAction.swift
//  BaseProject
//
//  Created by Tam Le on 02/09/2021.
//  Copyright © 2021 Tam Le. All rights reserved.
//

import UIKit

class AlertAction {
    var title: String = ""
    var style: AlertActionStyle = .normal
    var onClick: ((String) -> Void)? = nil
    
    init(title: String, style: AlertActionStyle, onClick: ((String) -> Void)? = nil) {
        self.title = title
        self.style = style
        self.onClick = onClick
    }
}
