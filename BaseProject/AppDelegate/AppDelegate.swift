//
//  AppDelegate.swift
//  BaseProject
//
//  Created by Tam Le on 7/28/20.
//  Copyright © 2020 Tam Le. All rights reserved.
//

import Foundation
import UIKit
import Localize
import GoogleMobileAds
import Firebase
import Siren
import MKProgress
import Kingfisher
import AppsFlyerLib

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    @Inject
    var eventTracking: EventTracking
    @Inject
    var remoteConfigManager: RemoteConfigManager
    @Inject
    var openAdManager: AppOpenAdManager
    
    var window: UIWindow?
    var isLightForegroundStatusBar = false
    var orientationLock = UIInterfaceOrientationMask.all
    
    private var mainVCDidAppear = false
    
    static func shared() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        windowSplashConfig()
        
        inappConfig()
        adsConfig()
        appFlyersConfigs()
        firebaseConfig()
        localizeConfig()
        mkProgressConfig()
        setupKingfisher()
        
        eventTracking.configSearchAds()
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        RxBus.shared.post(event: BusEvents.DidBecomeActive())
        AppUtils.requestIDFA() {
            DispatchQueue.main.async {
                self.openAppAdsConfigPresent()
                self.remoteConfigManager.fetchConfig {
                    self.eventTracking.startWith(self.remoteConfigManager)
                }
            }
        }
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return orientationLock
    }
}

extension AppDelegate {
    private func windowSplashConfig() {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        self.window?.rootViewController = SplashVC()
        self.window?.makeKeyAndVisible()
    }
    
    func windowMainConfig() {
        guard let window = window else { return }
        if (mainVCDidAppear) { return }
        
        let vc = MainVC()
        let nvc = BaseNVC(rootViewController: vc)
        
        let snapShotView = window.snapshotView(afterScreenUpdates: true)
        if snapShotView != nil {
            vc.view.addSubview(snapShotView!)
        }
        
        window.rootViewController = nvc
        mainVCDidAppear = true
        
        if snapShotView != nil {
            UIView.animate(withDuration: 0.5, animations: {
                snapShotView!.layer.opacity = 0
                snapShotView!.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5)
            }, completion: { isFinish in
                snapShotView!.removeFromSuperview()
            })
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.sirenConfig()
            if Configs.InAppPurcharse.enableShowInAppWhenOpenApp {
                vc.showInAppVC()
            }
            if Configs.NotificationLocal.enableLocalNotification {
                self.notificationConfig()
            }
        })
    }
}

extension AppDelegate {
    private func inappConfig() {
        IAPManager.shared().setupIAP(sharedSecret: Configs.InAppPurcharse.iAPSubcriptionSecret)
    }
    
    private func adsConfig() {
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        AdManager.shared.initAdWith(
            appOpenAdId: Configs.Advertisement.openAppAdsId,
            interstitialAdId: Configs.Advertisement.admobInterstitialId,
            rewardInterstitalAdId: Configs.Advertisement.admobRewardedVideoId,
            timedelayShowInterstitalAd: Configs.Advertisement.timedelayShowInterstitalAd
        )
    }
    
    private func appFlyersConfigs() {
        AppsFlyerLib.shared().appsFlyerDevKey = Configs.InfoApp.appsFlyerId
        AppsFlyerLib.shared().appleAppID = Configs.InfoApp.appId
#if DEBUG
        AppsFlyerLib.shared().isDebug = true
#endif
        AppsFlyerLib.shared().waitForATTUserAuthorization(timeoutInterval: 30)    }
    
    private func openAppAdsConfigPresent() {
        let rootVC = window?.rootViewController
        if rootVC != nil && (rootVC!.isKind(of: InAppProductVC.self) || rootVC!.isKind(of: WebviewVC.self)) {
            return
        }
        openAdManager.tryToPresentAd(rootVC) {
            if rootVC!.isKind(of: SplashVC.self) {
                self.windowMainConfig()
            }
        }
    }
    
    private func localizeConfig() {
        // Set your localize provider.
        Localize.update(provider: .strings)
        // Set your file name
        Localize.update(fileName: "Localizable")
        // Set your default languaje.
        Localize.update(defaultLanguage: "en")
    }
    
    private func firebaseConfig() {
        FirebaseApp.configure()
    }
    
    private func sirenConfig() {
        if Configs.InfoApp.enableShowUpdateAppDialog {
            Siren.shared.wail()
        }
    }
    
    private func mkProgressConfig() {
        MKProgress.config.hudColor = .white
        MKProgress.config.circleBorderColor = Theme.Colors.accent
        MKProgress.config.logoImage = Bundle.main.icon?.withRoundedCorners()
    }
    
    private func setupKingfisher() {
        // Setup Kingfisher image cache
        ImageCache.default.diskStorage.config.sizeLimit = 128 * 1024 * 1024
        ImageCache.default.memoryStorage.config.totalCostLimit = 2 * 1024 * 1024
    }
}

