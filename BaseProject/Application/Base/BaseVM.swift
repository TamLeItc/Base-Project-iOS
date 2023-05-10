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
import GoogleMobileAds

class BaseVM: NSObject {
    
    let subscriptionSucceed = PublishData<Bool>()
    let indicatorLoading = ActivityIndicator()
    let errorTracker = ErrorTracker()
    let loadingData = PublishData<Bool>()
    let messageData = PublishData<AlertMessage>()
    let showInAppData = PublishData<Void>()
    let showWebviewData = PublishData<String>()
    
    @Inject
    var remoteRepository: RemoteRepository
    @Inject
    var localRespository: LocalRespository
    @Inject
    var nativeAdManager: NativeAdManager
    
    let bag = DisposeBag()
    
    required override init() {
        super.init()
        
        IAPManager.shared().subscriptionSucceed {[weak self] isPurchased in
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

extension BaseVM {
    func fetchNativeAds(_ rootVC: UIViewController) {
        nativeAdManager.loadAd(rootVC, nativeAdId: Configs.Advertisement.admobNativeAdId)
    }
    
    func subcriptionMergeAds<T>(
        withDataRelay dataRelay: BehaviorRelay<[T]>,
        offset: MergeOffset
    ) -> Observable<(items: [T], mergeList: [ItemOrAd<T>])> {
        return Observable<(items: [T], mergeList: [ItemOrAd<T>])>
            .combineLatest(
                dataRelay.asObservable(),
                Observable.merge(
                    nativeAdManager.subsNativeAds(),
                    subscriptionSucceed.map { isPurchased in
                        if isPurchased {
                            return [GADNativeAd]()
                        } else {
                            return self.nativeAdManager.getNativeAds()
                        }
                    }
                )
            ) { items, ads -> (items: [T], mergeList: [ItemOrAd<T>]) in
                if (UIDevice.isPad) {
                    return (items: items, mergeList: mergeData(items, with: ads, offset: offset.pad))
                } else {
                    return (items: items, mergeList: mergeData(items, with: ads, offset: offset.phone))
                }
            }
    }
}
