//
//  BaseNVC.swift
//  BaseProject
//
//  Created by Tam Le on 16/09/2022.
//  Copyright © 2022 Tam Le. All rights reserved.
//

import UIKit

class BaseNVC: UINavigationController {
    
    var isLightForegroundStatusBar = false {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return isLightForegroundStatusBar ? .lightContent : .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isLightForegroundStatusBar = AppDelegate.shared().isLightForegroundStatusBar
    }
    
}
