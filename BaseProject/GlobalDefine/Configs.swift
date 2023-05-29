//
//  Configs.swift
//  BaseProject
//
//  Created by Tam Le on 7/28/20.
//  Copyright © 2020 Tam Le. All rights reserved.
//

import Foundation
import UIKit

//MARK:     -- NOTES
//  When you release, please don't edit anything in this file
//  Go to AppRelease.plist and Info.plist to edit app info
//  AppGroupID does not need to edit the value

enum Configs {
    
    //MARK: -- Info App
    enum InfoApp {
        static let appId = AppConfigs.shared.applicationID()
        static let appsFlyerId = AppConfigs.shared.appsFlyerID()
        static let email = AppConfigs.shared.emailDeveloper()
        static let appGroup = AppConfigs.shared.appGroupID()
        static let policyUrl = AppConfigs.shared.privacyPolicyUrl()
        static let termOfUseUrl = AppConfigs.shared.termOfUseUrl()
        static let refundUrl = AppConfigs.shared.refundUrl()
        static let enableShowUpdateAppDialog = AppConfigs.shared.enableShowUpdateAppDialog() // if true app will auto show dialog require udpate app
    }
    
    //MARK: -- Server
    enum Server {
        static let baseURL = "https://jsonplaceholder.typicode.com/"
        static let searchAdsTrackingBaseURL = AppConfigs.shared.searchAdsTrackingBaseURL()
    }
    
    //MARK: -- Network
    enum Network {
        static let perPage = 10
        static let networkTimeout:Double = 30 //second
        static let appOpenAdsLoadTimeout: TimeInterval = 15
    }
    
    //MARK: -- Advertisement
    enum Advertisement {
        static let numberOfNativeAdsLoaded = 5
        static let offsetNativeAdsAndItem = 4
        
        static let enableShowAds = AppConfigs.shared.enableShowAds()
        
        static let timedelayShowInterstitalAd = AppConfigs.shared.timeDelayShowInterstitalAd()
        
        static let openAppAdsId = AppConfigs.shared.appOpenAdsID()
        static let admobBannerId = AppConfigs.shared.bannerAdsID()
        static let admobInterstitialId = AppConfigs.shared.interstitialAdsID()
        static let admobRewardedVideoId = AppConfigs.shared.rewardedAdsID()
        static let admobNativeAdId = AppConfigs.shared.nativeAdsID()
    }
    
    //MARK: -- InAppPurcharse
    enum InAppPurcharse {
        static let enableShowInApp = AppConfigs.shared.enableShowInApp()
        static let enableShowInAppWhenOpenApp = AppConfigs.shared.enableShowInAppWhenOpenApp()
        static let limitedFeature = AppConfigs.shared.limitedFeature()
        
        static let iAPSubcriptionSecret = AppConfigs.shared.iAPSubcriptionSecret()
        //list products
        static let oneTime = AppConfigs.shared.iapOneTime()
        static let monthly = AppConfigs.shared.iAPMonthly()
        static let yearly = AppConfigs.shared.iAPYearly()
    }
    
    //MARK: -- InAppPurcharse
    enum NotificationLocal {
        static let enableLocalNotification = AppConfigs.shared.enableLocalNotification()
        static let timeTriggerNoti = AppConfigs.shared.timeTriggerNotification() //86400 seconds = 1 day
        static let contentTrigger : [(title:String, body:String)] = [
            (title: "local_noti_title_1".localized, body: "local_noti_content_1".localized)
        ]
    }
}

//MARK: Read: AppDebug.plist or AppRelease.plist
//Load info configs from file App plist
fileprivate class AppConfigs {
    
    fileprivate static let shared = AppConfigs()
    
    private var appInfos : [String: Any] = [:]
    private var servers : [String: Any] = [:]
    private var advertisementInfos : [String: Any] = [:]
    private var inAppPurcharseInfos : [String: Any] = [:]
    private var localNotificationInfos : [String: Any] = [:]
    
    fileprivate init() {
        readAppConfigInfo()
        
        print("applicationID: \(applicationID())")
        print("emailDeveloper: \(emailDeveloper())")
        print("appGroupID: \(appGroupID())")
        print("privacyPolicyUrl: \(privacyPolicyUrl())")
        print("termOfUseUrl: \(termOfUseUrl())")
        print("enableShowUpdateAppDialog: \(enableShowUpdateAppDialog())")
        
        print("enableShowAds: \(enableShowAds())")
        print("timeDelayShowInterstitalAd: \(timeDelayShowInterstitalAd())")
        print("bannerAdsID: \(bannerAdsID())")
        print("nativeAdsID: \(nativeAdsID())")
        print("rewardedVideoAdsID: \(rewardedAdsID())")
        print("appOpenAdsID: \(appOpenAdsID())")
        
        print("enableShowInApp: \(enableShowInApp())")
        print("enableShowInAppWhenOpenApp: \(enableShowInAppWhenOpenApp())")
        print("iAPSubcriptionSecret: \(iAPSubcriptionSecret())")
        print("iapOneTime: \(iapOneTime())")
        print("iAPMonthly: \(iAPMonthly())")
        print("iAPYearly: \(iAPYearly())")
        
        print("enableLocalNotification: \(enableLocalNotification())")
        print("timeTriggerNotification: \(timeTriggerNotification())")
    }
    
    //MARK: AppConfigs info app
    
    func applicationID() -> String {
        return appInfos["ApplicationID"] as? String ?? ""
    }
    
    func appsFlyerID() -> String {
        return appInfos["AppsFlyerID"] as? String ?? ""
    }
    
    func emailDeveloper() -> String {
        return appInfos["EmailDeveloper"] as? String ?? ""
    }
    
    func appGroupID() -> String {
        return appInfos["AppGroupID"] as? String ?? ""
    }
    
    func privacyPolicyUrl() -> String {
        return appInfos["PrivacyPolicyUrl"] as? String ?? ""
    }
    
    func termOfUseUrl() -> String {
        return appInfos["TermOfUseUrl"] as? String ?? ""
    }
    
    func refundUrl() -> String {
        return appInfos["RefundUrl"] as? String ?? ""
    }
    
    func enableShowUpdateAppDialog() -> Bool {
        if let value = appInfos["EnableShowUpdateAppDialog"] as? String, value == "YES" {
            return true
        } else {
            return false
        }
    }
    
    //MARK: Server
    func searchAdsTrackingBaseURL() -> String {
        return servers["SearchAdsTrackingBaseURL"] as? String ?? ""
    }
    
    //MARK: AppConfigs advertisement
    func enableShowAds() -> Bool {
        if let value = advertisementInfos["EnableShowAds"] as? String, value == "YES" {
            return true
        } else {
            return false
        }
    }
    
    func timeDelayShowInterstitalAd() -> TimeInterval {
        if let value = advertisementInfos["TimeDelayShowInterstitalAd"] as? String, let time = TimeInterval(value) {
            return time
        }
        return 45
    }
    
    func bannerAdsID() -> String {
        return advertisementInfos["ADSBannerID"] as? String ?? ""
    }
    
    func nativeAdsID() -> String {
        return advertisementInfos["ADSNativeID"] as? String ?? ""
    }
    
    func interstitialAdsID() -> String {
        return advertisementInfos["ADSInterstitialID"] as? String ?? ""
    }
    
    func rewardedAdsID() -> String {
        return advertisementInfos["ADSRewardedID"] as? String ?? ""
    }
    
    func appOpenAdsID() -> String {
        return advertisementInfos["ADSAppOpenID"] as? String ?? ""
    }
    
    //MARK: AppConfigs inAppPurcharse
    
    func enableShowInApp() -> Bool {
        if let value = inAppPurcharseInfos["EnableShowInApp"] as? String, value == "YES" {
            return true
        } else {
            return false
        }
    }
    
    func enableShowInAppWhenOpenApp() -> Bool {
        if let value = inAppPurcharseInfos["EnableShowInAppWhenOpenApp"] as? String, value == "YES" {
            return true
        } else {
            return false
        }
    }
    
    func limitedFeature() -> Bool {
        if let value = inAppPurcharseInfos["LimitedFeature"] as? String, value == "YES" {
            return true
        } else {
            return false
        }
    }
    
    func iAPSubcriptionSecret() -> String {
        return inAppPurcharseInfos["IAPSubcriptionSecret"] as? String ?? ""
    }
    
    func iapOneTime() -> String {
        return inAppPurcharseInfos["IAPOneTime"] as? String ?? ""
    }
    
    func iAPMonthly() -> String {
        return inAppPurcharseInfos["IAPMonthly"] as? String ?? ""
    }
    
    func iAPYearly() -> String {
        return inAppPurcharseInfos["IAPYearly"] as? String ?? ""
    }
    
    //MARK: AppConfigs localNotification
    
    func enableLocalNotification() -> Bool {
        if let value = localNotificationInfos["EnableLocalNotification"] as? String, value == "YES" {
            return true
        } else {
            return false
        }
    }
    
    func timeTriggerNotification() -> TimeInterval {
        if let value = localNotificationInfos["TimeTriggerNotification"] as? String, let time = TimeInterval(value) {
            return time
        }
        return 81600
    }
    
    //MARK: AppConfigs read file
    private func readAppConfigInfo() {
        appInfos = Configs.stringValue(forKey: "AppInfo") as! [String : Any]
        servers = Configs.stringValue(forKey: "Server") as! [String : Any]
        advertisementInfos = Configs.stringValue(forKey: "Advertisement") as! [String : Any]
        inAppPurcharseInfos = Configs.stringValue(forKey: "InAppPurcharse") as! [String : Any]
        localNotificationInfos = Configs.stringValue(forKey: "LocalNotification") as! [String : Any]
    }
}

extension Configs {
    static func stringValue(forKey key: String) -> Any {
        guard let appConfigs = Bundle.main.object(forInfoDictionaryKey: "AppConfigs") as? Dictionary<String, Any>
        else {
            fatalError("Invalid value or undefined key")
        }
        guard let value = appConfigs[key]
        else {
            fatalError("Invalid value or undefined key")
        }
        return value
    }
}
