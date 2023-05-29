//
//  BaseViewController.swift
//  BaseProject
//
//  Created by Tam Le on 7/28/20.
//  Copyright © 2020 Tam Le. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxRelay
import GoogleMobileAds

class BaseVC<VM: BaseVM>: UIViewController {
    
    @Inject
    var viewModel: VM!
    
    let bag = DisposeBag()
    
    var keyboardIsShow = false
    var enablePopGestureRecognizer = true
    
    var isLightForegroundStatusBar = false {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return isLightForegroundStatusBar ? .lightContent : .default
    }
    
    private var isFeedbackDialogShowed = false
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isLightForegroundStatusBar = AppDelegate.shared().isLightForegroundStatusBar
        
        initViews()
        configureListView()
        addEventForViews()
        bindViewModel()
        loadBannerAds()
        
        viewModel.fetchNativeAds(self)
        
        print("viewDidLoad :: >>>> \(String(describing: self)) <<<<")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //Disable/Enable swipe left to back
        navigationController?.interactivePopGestureRecognizer?.isEnabled = enablePopGestureRecognizer
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func viewDidBecomeActive() { }
    
    /**
     base setup views
     setup background, foreground corner, border, shadow
     setup textColor, tintColor
     register cell
     default data, default text,...
     e.t.c
     */
    func initViews() { }
    
    //Configure layout for collectionView
    func configureListView() { }
    
    /**
     setup rx action
     setup gesture
     e.t.c
     */
    func addEventForViews() { }
    
    /**
     Listener Rx from ViewModel
     */
    func bindViewModel() {
        RxBus.shared.asObservable(event: BusEvents.DidBecomeActive.self)
            .subscribe(onNext: {[weak self] _ in
                guard let self = self else { return }
                self.viewDidBecomeActive()
            }).disposed(by: bag)
        
        viewModel.indicatorLoading.asObservable()
            .subscribe(onNext: {[weak self] isLoading in
                guard let self = self else { return }
                UIApplication.shared.isNetworkActivityIndicatorVisible = isLoading
                isLoading ? self.showLoading() : self.hideLoading()
            }).disposed(by: bag)
        
        viewModel.loadingData
            .subscribe(onNext: {[weak self] isLoading in
                guard let self = self else { return }
                isLoading ? self.showLoading() : self.hideLoading()
            })
            .disposed(by: bag)
        
        viewModel.errorTracker
            .map { error in
                if let error = error as? BaseError, error.description.isNotEmpty {
                    return error.description
                } else {
                    return "general_error_message".localized
                }
            }
            .drive(onNext: {[weak self] errorMessage in
                guard let self = self else { return }
                self.showError(errorMessage)
            }).disposed(by: bag)
        
        viewModel.messageData
            .subscribe(onNext: {[weak self] message in
                guard let self = self else { return }
                AlertVC.showMessage(self, message: message)
            }).disposed(by: bag)
        
        viewModel.showInAppData
            .subscribe(onNext: {[weak self] in
                guard let self = self else { return }
                self.showInAppVC()
            })
            .disposed(by: bag)
        
        viewModel.showWebviewData
            .subscribe(onNext: {[weak self] url in
                guard let self = self else { return }
                self.showWebviewVC(url: url)
            }).disposed(by: bag)
    }
    
    func loadBannerAds() {}
    
    /**
     When VC cannot deinit
     You should use this function when dismiss or popBack Viewcontroller to clear references, data,...
     */
    func clearAll() {}
    
    @objc func keyboardWillShow(notification: NSNotification) {
        keyboardIsShow = true
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        keyboardIsShow = false
    }
    
    deinit {
        print("deinit :: >>>> \(String(describing: self)) <<<<")
    }
}

extension BaseVC {
    func showFeedbackDialog() {
        if (isFeedbackDialogShowed) {
            return
        }
        if UserDefaultHelper.shared.isReviewed {
            AppUtils.rateForApp()
        } else {
            let alert = AlertVC(title: "review_app_title".localized, message: "review_app_message".localized, style: .alert)
            alert.addAction(AlertAction(title: "later".localized, style: .cancel, onClick: {_ in
                
            }))
            alert.addAction(AlertAction(title: "review".localized, style: .confirm, onClick: {_ in
                AppUtils.openReviewAppInStore()
                UserDefaultHelper.shared.isReviewed = true
            }))
            isFeedbackDialogShowed = true
            presentVC(alert)
        }
    }
}
