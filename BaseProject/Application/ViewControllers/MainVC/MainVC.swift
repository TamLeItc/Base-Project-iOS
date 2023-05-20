//
//  MainVC.swift
//  BaseProject
//
//  Created by Tam Le on 8/27/20.
//  Copyright © 2020 Tam Le. All rights reserved.
//

import UIKit

class MainVC: BaseVC<MainVM> {
    
    @IBOutlet weak var button: UIButton!
    
    let a: [String: String] = [:]
    
    override func addEventForViews() {
        super.addEventForViews()
        
        button.rx.tap
            .subscribe(onNext: {[weak self] _ in
                guard let self = self else { return }
                self.pushVC(DemoMainVC())
            }).disposed(by: bag)
    }
}
