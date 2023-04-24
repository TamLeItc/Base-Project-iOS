//
//  RewardedAdImp.swift
//  i270-locksafe
//
//  Created by Tam Le on 24/04/2023.
//

import GoogleMobileAds

class RewardedAdManagermp: NSObject, RewardedAdManager {
    private var rewardedInterstitalAd: GADRewardedInterstitialAd!
    
    private var numOfLoadInterstitialAds = 5
    private var rewardInterstitalAdId: String!
    
    private var onAdClosed: ((_ reward: GADAdReward?) -> Void)?
    private var onPresentFailed: (() -> Void)?
    
    private var hasReward = false
    
    func initWith(_ adId: String) {
        rewardInterstitalAdId = adId
        loadRewardAd()
    }
    
    public func showAd(_ viewController: UIViewController,
                             onAdClosed: ((_ reward: GADAdReward?) -> Void)?,
                             onPresentFailed: (() -> Void)?) {
        
        self.onAdClosed = onAdClosed
        self.onPresentFailed = onPresentFailed
        
        hasReward = false
        if rewardedInterstitalAd != nil {
            do {
                try rewardedInterstitalAd.canPresent(fromRootViewController: viewController)
                rewardedInterstitalAd.present(fromRootViewController: viewController, userDidEarnRewardHandler: {[weak self] in
                    guard let self = self else { return }
                    self.hasReward = true
                })
                return
            } catch { }
        }
        
        self.onPresentFailed?()
    }
    
    private func loadRewardAd() {
        GADRewardedInterstitialAd.load(withAdUnitID: rewardInterstitalAdId, request: GADRequest(), completionHandler: {ad, error in
            if (error == nil) {
                self.rewardedInterstitalAd = ad
                self.rewardedInterstitalAd.fullScreenContentDelegate = self
            }
        })
    }
}

extension RewardedAdManagermp: GADFullScreenContentDelegate {
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        onPresentFailed?()
        loadRewardAd()
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        if hasReward {
            onAdClosed?(rewardedInterstitalAd.adReward)
        } else {
            onAdClosed?(nil)
        }
        loadRewardAd()
    }
}
