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
    
    @Inject
    var intersAd: IntersAdManager
    @Inject
    var rewarded: RewardedAdManager
    @Inject
    var appOpenAd: AppOpenAdManager
    
    static var canShowAds: Bool {
        if !IAPHelper.shared().isSubscribed() && Configs.Advertisement.enableShowAds {
            return true
        } else {
            return false
        }
    }
    
    private override init() {}
    
    public func initAdWith(
        appOpenAdId: String,
        interstitialAdId: String,
        rewardInterstitalAdId: String,
        timedelayShowInterstitalAd: TimeInterval
    ){
        appOpenAd.initWith(appOpenAdId)
        rewarded.initWith(rewardInterstitalAdId)
        intersAd.initWith(interstitialAdId, timeDelayForNextShow: timedelayShowInterstitalAd)
    }
}
