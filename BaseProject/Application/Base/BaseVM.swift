//
//  BaseViewModel.swift
//  BaseProject
//
//  Created by Tam Le on 7/29/20.
//  Copyright © 2020 Tam Le. All rights reserved.
//

import Foundation
import RxSwift
import RxSwift
import RxCocoa

class BaseVM: NSObject {
    
    let subscriptionSucceed = PublishData<Bool>()
    let indicatorLoading = ActivityIndicator()
    let loadingData = PublishData<Bool>()
    let errorTracker = ErrorTracker()
    let infoMessage = PublishData<String>()
    let warningMessage = PublishData<String>()
    let errorMessage = PublishData<String>()
    let showInAppData = PublishData<Void>()
    let showWebviewData = PublishData<String>()
    
    @Inject
    var remoteRepository: RemoteRepository
    @Inject
    var localRespository: LocalRespository
    
    let bag = DisposeBag()
    
    required override init() {
        super.init()
        
        IAPHelper.shared().subscriptionSucceed {[weak self] isPurchased in
            guard let self = self else { return }
            self.subscriptionSucceed.accept((isPurchased))
        }
        
        registerLisenBusEvent()
    }
    
    func registerLisenBusEvent()  {}
    
    deinit {
        print("deinit viewmodel :: >>>> \(String(describing: self)) <<<<")
    }
}
