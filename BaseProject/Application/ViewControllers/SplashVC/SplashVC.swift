//
//  SplashVC.swift
//  BaseProject
//
//  Created by Tam Le on 10/16/20.
//  Copyright © 2020 Tam Le. All rights reserved.
//

import UIKit

class SplashVC: BaseVC<SplashVM> {
    
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !AdsHelper.canShowAds {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                AppDelegate.shared().windowMainConfig()
            })
        }
    }
    
    override func initViews() {
        indicatorView.startAnimating()
    }
    
}
