//
//  NativeAdManager.swift
//  BaseProject
//
//  Created by Tam Le on 9/4/20.
//  Copyright © 2020 Tam Le. All rights reserved.
//

import GoogleMobileAds
import RxRelay
import RxSwift

class  NativeAdManager: NSObject {
    
    var nativeAds: [GADNativeAd] = []
    
    private var adLoader: GADAdLoader!
    
    private let nativeAdsRelay = BehaviorRelay<[GADNativeAd]>(value: [])
    
    private var isReloadedAds = false
    
    public init(_ rootVC: UIViewController, nativeAdId: String) {
        super.init()
        
        let multipleAdsOptions = GADMultipleAdsAdLoaderOptions()
        multipleAdsOptions.numberOfAds = Configs.Advertisement.numberOfNativeAdsLoaded
        
        adLoader = GADAdLoader(adUnitID: nativeAdId, rootViewController: rootVC,
                               adTypes: [GADAdLoaderAdType.native],
                               options: [multipleAdsOptions])
        adLoader.delegate = self
        
        loadAds()
    }
    
    func loadAds() {
        if nativeAds.count >= Configs.Advertisement.numberOfNativeAdsLoaded || !AdsHelper.canShowAds {
            return
        }
        
        adLoader.load(GADRequest())
    }
    
    var nativeAds$: Observable<[GADNativeAd]> {
        nativeAdsRelay.map {
            if AdsHelper.canShowAds {
                return $0
            }
            return []
        }
    }
    
}

extension NativeAdManager: GADNativeAdLoaderDelegate {
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
        nativeAds.append(nativeAd)
    }
    
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        print("ADMOB: \(error.localizedDescription)")
    }
    
    func adLoaderDidFinishLoading(_ adLoader: GADAdLoader) {
        
        //Finish reload. If list add empty then request ads again
        if !isReloadedAds && nativeAds.isEmpty {
            loadAds()
            isReloadedAds = true
            return
        }
        else {
            print("ADMOB: Finish load ad \(nativeAds.count)")
            
            if AdsHelper.canShowAds {
                return nativeAdsRelay.accept(nativeAds)
            } else {
                return nativeAdsRelay.accept([])
            }
        }
    }
}
