////
////  AdsUtils.swift
////  BaseProject
////
////  Created by Tam Le on 8/19/20.
////  Copyright © 2020 Tam Le. All rights reserved.
////
//
import Foundation
import GoogleMobileAds

class AdsHelper: NSObject {
    
    public static let shared: AdsHelper = .init()
    
    public var interstitalAd: InterstitialAdManager!
    public var rewardAd: RewardAdManager!
    public var nativeAd: NativeAdManager!
    
    static var canShowAds: Bool {
        if !IAPHelper.shared().isSubscribed() && Configs.Advertisement.enableShowAds {
            return true
        } else {
            return false
        }
    }
    
    private override init() {}
    
    public func initWith(rootVC: UIViewController,
                         interstitialAdId: String,
                         rewardInterstitalAdId: String,
                         nativeAdId: String){
        interstitalAd = InterstitialAdManager.init(interstitialAdId)
        rewardAd = RewardAdManager.init(rewardInterstitalAdId)
        nativeAd = NativeAdManager.init(rootVC, nativeAdId: nativeAdId)
    }
    
}
