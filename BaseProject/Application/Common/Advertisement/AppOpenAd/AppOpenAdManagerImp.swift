//
//  AppOpenAdManagerImp.swift
//  i270-locksafe
//
//  Created by Tam Le on 24/04/2023.
//

import Foundation
import GoogleMobileAds

class AppOpenAdManagerImp: NSObject, AppOpenAdManager {
    
    private var appOpenAd: GADAppOpenAd!
    private var openAppAdId: String = ""
    
    private var loadTime: Date?
    private var timer: Timer?
    private var isFirstTimeLoadAd = true
    private var isRequestOpenAd = false
    private var rootController: UIViewController?
    
    private var onCompleted: (() -> Void)?
    
    func initWith(_ adId: String) {
        openAppAdId = adId
    }
    
    func tryToPresentAd(
        _ rootController: UIViewController?,
        onCompleted: (() -> Void)?
    ) {
        self.rootController = rootController
        self.onCompleted = onCompleted
        
        if !AdsHelper.canShowAds || !ConnectionHelper.shared.isInternetAvailable() {
            handleCompleted()
            return
        }
        
        let ad = self.appOpenAd
        self.appOpenAd = nil
        
        if ad != nil && wasLoadTimeLessThanNHoursAgo(4) {
            if rootController != nil {
                let isCanPresent: Bool = ((try? ad!.canPresent(fromRootViewController: rootController!)) != nil)
                if isCanPresent {
                    ad!.present(fromRootViewController: rootController!)
                } else {
                    handleCompleted()
                }
            }
        } else {
            requestAppOpenAd()
        }
    }
    
    private func requestAppOpenAd() {
        
        if (isRequestOpenAd) { return }
        
        self.appOpenAd = nil
        if isFirstTimeLoadAd {
            startCountdownTimeout()
        } else {
            rootController = nil
        }
        
        isRequestOpenAd = true
        GADAppOpenAd.load(withAdUnitID: openAppAdId, request: GADRequest(), orientation: UIInterfaceOrientation.portrait, completionHandler: {[self] appOpenAd, error in
            
            isRequestOpenAd = false
            
            if let _ = error {
                handleCompleted()
                print("App Open Ad Present Failed: \(String(describing: error))")
            } else {
                self.isFirstTimeLoadAd = false
                self.appOpenAd = appOpenAd;
                self.appOpenAd.fullScreenContentDelegate = self
                
                loadTime = Date()
                
                //If rootController is SplashVC => First show Open App ads
                //otherwise do nothing.
                if rootController != nil && rootController!.isKind(of: SplashVC.self) {
                    let isCanPresent: Bool = ((try? appOpenAd!.canPresent(fromRootViewController: rootController!)) != nil)
                    if isCanPresent {
                        appOpenAd!.present(fromRootViewController: rootController!)
                        self.timer?.invalidate()
                    } else {
                        handleCompleted()
                    }
                }
            }
        })
    }
    
    private func handleCompleted() {
        rootController = nil
        onCompleted?()
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.2, execute: {
            self.onCompleted = nil
        })
    }
    
    private func startCountdownTimeout() {
        timer = Timer.scheduledTimer(timeInterval: Configs.Network.appOpenAdsLoadTimeout, target: self, selector: #selector(loadAdTimeout), userInfo: nil, repeats: false)
    }
    
    private func wasLoadTimeLessThanNHoursAgo(_ n: Int) -> Bool {
        if loadTime == nil {
            return false
        }
        let timeIntervalBetweenNowAndLoadTime = Date().timeIntervalSince(loadTime!)
        let intervalInHours = timeIntervalBetweenNowAndLoadTime / 3600
        return intervalInHours < Double(n)
    }
}

extension AppOpenAdManagerImp {
    @objc func loadAdTimeout() {
        if isFirstTimeLoadAd {
            handleCompleted()
            isFirstTimeLoadAd = false
        }
    }
}

extension AppOpenAdManagerImp: GADFullScreenContentDelegate {
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("App Open Ad Present Failed: \(error)")
        handleCompleted()
    }
    
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("App Open Ad Present Success")
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        requestAppOpenAd()
        handleCompleted()
    }
}
