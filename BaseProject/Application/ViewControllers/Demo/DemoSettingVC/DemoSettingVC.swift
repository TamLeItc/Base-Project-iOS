//
//  DemoSettingVC.swift
//  BaseProject
//
//  Created by Tam Le on 16/07/2021.
//  Copyright © 2021 Tam Le. All rights reserved.
//

import UIKit

class DemoSettingVC: BaseVC<DemoSettingVM> {
    
    let a = 10
    var b = 10
    
    let c: Int? = nil
    let d: Int? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        enablePopGestureRecognizer = false
        
        
    }

}
