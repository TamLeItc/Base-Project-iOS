//
//  DemoPageMainVC.swift
//  BaseProject
//
//  Created by Tam Le on 16/07/2021.
//  Copyright © 2021 Tam Le. All rights reserved.
//

import UIKit


class DemoMainVC: BaseVC<DemoMainVM> {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var pageView: UIView!
    @IBOutlet weak var adView: UIView!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var settingButton: UIButton!
    
    private var pageVC: BasePageVC<BasePageVM>!
    private var isSetupPageView = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        enablePopGestureRecognizer = false
        
    }
    
    override func initViews() {
        super.initViews()
        
        homeButton.backgroundColor = Theme.Colors.accent
        settingButton.backgroundColor = .white
        
        setupPageView()
    }
    
    override func addEventForViews() {
        backButton.rx.tap
            .subscribe(onNext: {[weak self] in
                guard let self = self else { return }
                self.clearAll()
                self.popVC()
            }).disposed(by: bag)
        
        homeButton.rx.tap
            .subscribe(onNext: {[weak self] in
                guard let self = self else { return }
                self.homeButton.backgroundColor = Theme.Colors.accent
                self.settingButton.backgroundColor = .white
                RxBus.shared.post(event: BusEvents.ChangePage(page: 0))
            }).disposed(by: bag)
        
        settingButton.rx.tap
            .subscribe(onNext: {[weak self] in
                guard let self = self else { return }
                self.homeButton.backgroundColor = .white
                self.settingButton.backgroundColor = Theme.Colors.accent
                RxBus.shared.post(event: BusEvents.ChangePage(page: 1))
            }).disposed(by: bag)
    }
    
    override func clearAll() {
        super.clearAll()
        
        pageVC.pages.removeAll()
        if pageVC != nil {
            pageVC.removeOutParent()
            pageVC = nil
        }
    }

    private func setupPageView() {
        if !isSetupPageView {
            pageVC = BasePageVC()
            pageVC.pages = [
                DemoHomeVC(),
                DemoSettingVC()
            ]
            pageVC.isPagingEnabled = false
            addChildToView(pageVC, toView: pageView)
        }
    }
}
