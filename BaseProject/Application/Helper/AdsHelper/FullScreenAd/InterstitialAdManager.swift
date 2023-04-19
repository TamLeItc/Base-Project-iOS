//
//  InterstitialAdHelper.swift
//  BaseProject
//
//  Created by Tam Le on 26/03/2021.
//  Copyright © 2021 Tam Le. All rights reserved.
//

import GoogleMobileAds

class InterstitialAdManager: NSObject {
    
    private var interstitialAd: GADInterstitialAd!
    
    private var numOfLoadInterstitialAds = 5
    private var interstitialAdId: String!
    
    private var onCompleted: (() -> Void)?
    
    private let timeDistance = Configs.Advertisement.timedelayShowInterstitalAd
    private var lastTimeShowAd = TimeInterval(0)
    
    public init(_ interstitialAdId: String) {
        super.init()
        self.interstitialAdId = interstitialAdId
        loadInterstitalAd()
    }
    
    public func showAd(_ viewController: UIViewController,
                                    onCompleted: (() -> Void)? = nil) {
        
        self.onCompleted = onCompleted
        if canShowInterstitialAd && interstitialAd != nil {
            interstitialAd.present(fromRootViewController: viewController)
            lastTimeShowAd = Date().timeIntervalSince1970
        } else {
            self.onCompleted?()
        }
    }
    
    private func loadInterstitalAd() {
        GADInterstitialAd.load(withAdUnitID: self.interstitialAdId, request: GADRequest(), completionHandler: {ad, error in
            if (error == nil) {
                self.interstitialAd = ad
                self.interstitialAd.fullScreenContentDelegate = self
            }
        })
    }
    
    private var canShowInterstitialAd: Bool {
        AdsHelper.canShowAds &&
            Date().timeIntervalSince1970 - lastTimeShowAd > timeDistance
    }
}

extension InterstitialAdManager: GADFullScreenContentDelegate {
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        onCompleted?()
        loadInterstitalAd()
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        onCompleted?()
        loadInterstitalAd()
    }
}
