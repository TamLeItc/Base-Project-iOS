//
//  NativeAdManagerImp.swift
//  BaseProject
//
//  Created by Tam Le on 9/4/20.
//  Copyright © 2020 Tam Le. All rights reserved.
//

import GoogleMobileAds
import RxRelay
import RxSwift

class  NativeAdManagerImp: NSObject, NativeAdManager {
    
    private var adLoader: GADAdLoader!
    private var nativeAds: [GADNativeAd] = []
    
    private let nativeAdsRelay = BehaviorRelay<[GADNativeAd]>(value: [])
    
    private var isReloadedAds = false
    
    func loadAd(_ rootVC: UIViewController, nativeAdId: String) {
        if !AdManager.canShowAds {
            return
        }
        createAdLoader(rootVC: rootVC, nativeAdId: nativeAdId)
        adLoader.delegate = self
        adLoader.load(GADRequest())
    }
    
    func getNativeAds() -> [GADNativeAd] {
        return nativeAds
    }
    
    func subsNativeAds() -> Observable<[GADNativeAd]> {
        nativeAdsRelay.map {
            if AdManager.canShowAds {
                return $0
            }
            return []
        }
    }
    
    private func createAdLoader(rootVC: UIViewController, nativeAdId: String) {
        let multipleAdsOptions = GADMultipleAdsAdLoaderOptions()
        multipleAdsOptions.numberOfAds = Configs.Advertisement.numberOfNativeAdsLoaded
        
        adLoader = GADAdLoader(adUnitID: nativeAdId, rootViewController: rootVC,
                               adTypes: [GADAdLoaderAdType.native],
                               options: [multipleAdsOptions])
    }
}

extension NativeAdManagerImp: GADNativeAdLoaderDelegate {
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
        nativeAds.append(nativeAd)
    }
    
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        print("ADMOB: \(error.localizedDescription)")
    }
    
    func adLoaderDidFinishLoading(_ adLoader: GADAdLoader) {
        
        //Finish reload. If list add empty then request ads again
        if !isReloadedAds && nativeAds.isEmpty {
            isReloadedAds = true
            return
        }
        else {
            print("ADMOB: Finish load ad \(nativeAds.count)")
            if AdManager.canShowAds {
                return nativeAdsRelay.accept(nativeAds)
            } else {
                return nativeAdsRelay.accept([])
            }
        }
    }
}
