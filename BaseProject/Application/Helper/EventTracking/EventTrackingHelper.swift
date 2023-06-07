//
//  EventTrackingHelper.swift
//  i270-locksafe
//
//  Created by Tam Le on 13/04/2023.
//

import Foundation
import AppsFlyerLib
import AdServices
import Alamofire
import Adjust

class EventTrackingHelper: NSObject {
    
    static let shared = EventTrackingHelper.init()
    
    private var analyticsData: [String : Any] = [:]
    
    func startWith() {
        
        configAdjust()
        configSearchAds()
        AppsFlyerLib.shared().start()
    }
    
    func configSearchAds() {
        recordAppleSearchAds()
    }
    
    func configsAppFlyer() {
        appFlyersConfigs()
    }
    
    func configAdjust() {
        adjustConfig(RemoteConfigHelper.shared.getStringValue(fromKey: .AdjustTokenKey))
    }
    
    func logEventInApp(_ product: IAPProduct?, type: EventTrackingType) {
        if (type == .restore) {
            logServerSearchAds(purchaseName: "restore")
        } else {
            guard let product = product else { return }
            logServerSearchAds(purchaseName: product.name)
            logAppsFlyerInAppEvents(
                id: product.skProduct.productIdentifier,
                type: type.rawValue,
                price: product.skProduct.price,
                currency: product.skProduct.priceLocale.currencyCode ?? "USD")
            logEventAdjustPurchase(
                productSelected: product,
                needMoney: Double(truncating: product.skProduct.price),
                currency: product.skProduct.priceLocale.currencyCode ?? "USD")
        }
    }
}

extension EventTrackingHelper {
    private func adjustConfig(_ appToken: String) {
#if DEBUG
        let environment = ADJEnvironmentSandbox as String
#else
        let environment = ADJEnvironmentProduction as String
#endif
        let adjustConfig = ADJConfig(
            appToken: appToken,
            environment: environment)
        
        adjustConfig?.delegate = self
        
        Adjust.appDidLaunch(adjustConfig)
    }
    
    private func appFlyersConfigs() {
        AppsFlyerLib.shared().appsFlyerDevKey = Configs.InfoApp.appsFlyerId
        AppsFlyerLib.shared().appleAppID = Configs.InfoApp.appId.replacingOccurrences(of: "id", with: "")
#if DEBUG
        AppsFlyerLib.shared().isDebug = true
#endif
        AppsFlyerLib.shared().waitForATTUserAuthorization(timeoutInterval: 30)    }
    
    private func recordAppleSearchAds() {
        if #available(iOS 14.3, *) {
            DispatchQueue.global(qos: .background).async {
                var attributionToken = ""
                do {
                    attributionToken = try AAAttribution.attributionToken()
                } catch {
                    print("applySearchAdAttribution: AttributionToken error: \(error)")
                }
                if let url = URL(string: "https://api-adservices.apple.com/api/v1/") {
                    let request = NSMutableURLRequest(url: url)
                    request.httpMethod = "POST"
                    request.setValue("text/plain", forHTTPHeaderField: "Content-Type")
                    request.httpBody = Data(attributionToken.utf8)
                    let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, _, error) in
                        guard let data = data, error == nil else { return }
                        do {
                            guard let data = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
                                return
                            }
                            if let campaignId = data["campaignId"] as? Int {
                                var logData = [String: Any]()
                                if campaignId != 1234567890 {
                                    logData["appID"] = Configs.InfoApp.appId
                                    logData["attribution"] = data["attribution"]
                                    logData["orgId"] = data["orgId"]
                                    logData["campaignID"] = campaignId
                                    logData["conversionType"] = data["conversionType"]
                                    logData["clickDate"] = data["clickDate"]
                                    logData["adGroupId"] = data["adGroupId"]
                                    logData["countryOrRegion"] = data["countryOrRegion"]
                                    logData["keywordId"] = data["keywordId"]
                                    logData["creativeSetId"] = data["creativeSetId"]
                                }
                                logData["attribution"] = UIDevice.current.systemVersion
                                print("LogEventHelper: analyticsData>>>>>>>>>>>")
                                print(logData)
                                self.analyticsData = logData
                            }
                        } catch {
                            print("LogEventHelper: analyticsData: error \(error)")
                        }
                    }
                    task.resume()
                }
            }
        }
    }
}

extension EventTrackingHelper {
    //MARK: -- Log Server search ads
    private func logServerSearchAds(purchaseName: String) {
        analyticsData["purchase"] = purchaseName
        AF.request(
            "\(Configs.Server.searchAdsTrackingBaseURL)api/log",
            method: .post,
            parameters: analyticsData,
            encoding: JSONEncoding.default
        ).responseJSON(queue: .global(qos: .background)) { response in
            switch response.result {
            case .success(let value):
                print(value, "@@@>")
            case .failure(let error):
                print(error, "@@@>")
            }
        }
    }
    
    
    //MARK: -- Appsflyer
    private func logAppsFlyerInAppEvents(id: String, type: String, price: NSDecimalNumber, currency: String) {
        AppsFlyerLib.shared().logEvent(
            AFEventPurchase,
            withValues: [
                AFEventParamContentId: id,
                AFEventParamContentType: type,
                AFEventParamPrice: price,
                AFEventParamCurrency: currency,
                AFEventParamRevenue: price
            ])
    }
    
    //MARK: -- Adjust
    private func logEventAdjustPurchase(productSelected: IAPProduct, needMoney: Double, currency: String) {
        let event = ADJEvent(eventToken: RemoteConfigHelper.shared.getStringValue(fromKey: .AdjustTokenPurchaseKey) ?? "")
        event?.setRevenue(needMoney, currency: currency)
        Adjust.trackEvent(event)
    }
}

extension EventTrackingHelper: AdjustDelegate {
    func adjustEventTrackingSucceeded(_ eventSuccessResponseData: ADJEventSuccess?) {
        print("[Adjust] adjustEventTrackingSucceeded")
    }
    
    func adjustEventTrackingFailed(_ eventFailureResponseData: ADJEventFailure?) {
        print("[Adjust] adjustEventTrackingFailed \(eventFailureResponseData?.description ?? "")")
    }
}
