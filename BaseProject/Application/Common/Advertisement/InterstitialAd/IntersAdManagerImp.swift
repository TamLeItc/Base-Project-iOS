//
//  IntersAdManagerImp.swift
//  i270-locksafe
//
//  Created by Tam Le on 24/04/2023.
//

import GoogleMobileAds

class IntersAdManagerImp: NSObject, IntersAdManager {
    
    private var interstitialAd: GADInterstitialAd!
    private var interstitialAdId: String!
    
    private var onCompleted: (() -> Void)?
    
    private var timeDelay: TimeInterval = 30
    private var lastTimeShowAd = TimeInterval(0)
    
    func initWith(_ adId: String, timeDelayForNextShow: TimeInterval) {
        interstitialAdId = adId
        timeDelay = timeDelayForNextShow
        loadInterstitalAd()
    }
    
    func showAd(_ viewController: UIViewController, onCompleted: (() -> Void)?) {
        self.onCompleted = onCompleted
        if canShowInterstitialAd && interstitialAd != nil {
            interstitialAd.present(fromRootViewController: viewController)
            lastTimeShowAd = Date().timeIntervalSince1970
        } else {
            onCompleted?()
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
            Date().timeIntervalSince1970 - lastTimeShowAd > timeDelay
    }
}

extension IntersAdManagerImp: GADFullScreenContentDelegate {
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        onCompleted?()
        loadInterstitalAd()
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        onCompleted?()
        loadInterstitalAd()
    }
}
