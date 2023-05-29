//
//  InAppProductVC.swift
//  BaseProject
//
//  Created by Tam Le on 8/19/20.
//  Copyright © 2020 Tam Le. All rights reserved.
//

import UIKit
import StoreKit
import SwiftyStoreKit
import RxCocoa
import RxRelay
import RxSwift
import RxDataSources
import GoogleMobileAds

class InAppProductVC: BaseVC<InAppProductVM> {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var inAppTableView: IntrinsicTableView!
    @IBOutlet weak var inappTableViewHC: NSLayoutConstraint!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var restoreButton: UIButton!
    @IBOutlet weak var startNowButton: UIButton!
    @IBOutlet weak var continueLimitedButton: UIButton!
    @IBOutlet weak var termButton: UIButton!
    @IBOutlet weak var privacyButton: UIButton!
    
    @IBOutlet weak var contentViewHC: NSLayoutConstraint!
    @IBOutlet weak var contentViewWC: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.didFetchData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        inappTableViewHC.constant = inAppTableView.intrinsicContentSize.height
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //428 x 926 is iphone 12 pro max
        var contentWidth: CGFloat = 428
        var contentHeight: CGFloat = 926
        if UIDevice().userInterfaceIdiom == .phone {
            contentWidth = self.view.frame.width
            contentHeight = self.view.frame.height - (UIDevice.safeArea.top + UIDevice.safeArea.bottom)
        }
        contentViewWC.constant = contentWidth
        contentViewHC.constant = contentHeight
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        clearAll()
    }

    override func initViews() {
        super.initViews()
        
        restoreButton.underline()
        termButton.underline()
        privacyButton.underline()
    }
    
    override func configureListView() {
        super.configureListView()
        inAppTableView.registerCellNib(TrialInAppCell.self)
        inAppTableView.registerCellNib(NormalInAppCell.self)
    }
    
    override func addEventForViews() {
        super.addEventForViews()
        
        restoreButton.rx.tap
            .subscribe(onNext: {[weak self] _ in
                guard let self = self else { return }
                self.viewModel.didRestore()
            }).disposed(by: bag)
        
        startNowButton.rx.tap
            .subscribe(onNext: {[weak self] _ in
                guard let self = self else { return }
                self.viewModel.didBuyProduct()
            }).disposed(by: bag)
        
        continueLimitedButton.rx.tap
            .subscribe(onNext: {[weak self] _ in
                guard let self = self else { return }
                self.dismiss(animated: true)
            }).disposed(by: bag)
        
        termButton.rx.tap
            .subscribe(onNext: {[weak self] _ in
                guard let self = self else { return }
                WebviewVC.showTermOfUse(self)
            }).disposed(by: bag)
        
        privacyButton.rx.tap
            .subscribe(onNext: {[weak self] _ in
                guard let self = self else { return }
                WebviewVC.showPolicy(self)
            }).disposed(by: bag)
        
        messageLabel.isUserInteractionEnabled = true
        let longPressRecognizer = UILongPressGestureRecognizer(
            target: self, action: #selector(longPressRestore(sender: )))
            messageLabel.addGestureRecognizer(longPressRecognizer)
        
        inAppTableView.rx
            .modelSelected(IAPProduct.self)
            .subscribe(onNext: { [weak self] item in
                guard let self = self else { return }
                self.viewModel.productSelected(item)
            })
            .disposed(by: bag)
    }

    override func bindViewModel() {
        super.bindViewModel()
        
        viewModel.inAppProductData.asObservable()
            .map { [SectionModel(model: (), items: $0)] }
            .bind(to: self.inAppTableView.rx.items(dataSource: getInAppDataSource()))
            .disposed(by: bag)

        viewModel.errorGetInAppMessage.asObservable().subscribe(onNext: {[weak self] message in
            guard let self = self else { return }
            AlertVC.showMessage(self, style: .error, message: message, onClick: {
                self.dismiss(animated: true)
            })
        }).disposed(by: bag)

        viewModel.purchased.asObservable().subscribe(onNext: {[weak self] message in
            guard let self = self else { return }
            AlertVC.showMessage(self, style: .info, message: message, onClick: {
                self.dismiss(animated: true)
            })
        }).disposed(by: bag)

        viewModel.loading.asObservable().subscribe(onNext: {[weak self] loading in
            guard let self = self else { return }
            loading ? self.showLoading() : self.hideLoading()
            UIApplication.shared.isNetworkActivityIndicatorVisible = loading
        }).disposed(by: bag)
    }
}

extension InAppProductVC {
    @IBAction func longPressRestore(sender: UILongPressGestureRecognizer) {
        AppUtils.showVoucherPremium(self)
    }
}
