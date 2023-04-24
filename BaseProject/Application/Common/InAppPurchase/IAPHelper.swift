//
//  IAPManager.swift
//  BaseProject
//
//  Created by Tam Le on 7/29/20.
//  Copyright © 2020 Tam Le. All rights reserved.
//

import Foundation
import SwiftyStoreKit
import TPInAppReceipt

import UIKit
import SwiftyStoreKit
import TPInAppReceipt

class IAPHelper {
    
    var memberShipStatus: Bool!{
        set{ UserDefaultHelper.shared.preferences?.set(newValue, forKey: USER_MEMBERSIP_PREMIUM_STATUS) }
        get{ return UserDefaultHelper.shared.preferences?.bool(forKey: USER_MEMBERSIP_PREMIUM_STATUS) }
    }
    var memberShipExpiredDay: String!{
        set{ UserDefaultHelper.shared.preferences?.set(newValue, forKey: USER_MEMBERSIP_PREMIUM_EXPIRED_DATE) }
        get{return UserDefaultHelper.shared.preferences?.string(forKey: USER_MEMBERSIP_PREMIUM_EXPIRED_DATE) }
    }
    
    private let USER_MEMBERSIP_PREMIUM_STATUS = "user_membership_status"    // premium membership
    private let USER_MEMBERSIP_PREMIUM_EXPIRED_DATE = "user_membership_expired_date"  // premium membership expire date
    
    private var sharedSecret :String!
    private var subscriptionCallBacks : [((_ isPurchased: Bool)-> Void)]!
    
    private static var shareInstance :IAPHelper = {
        let iapHelper = IAPHelper()
        return iapHelper
    }()
    
    init() {
        self.subscriptionCallBacks = []
    }
    
    class func shared() -> IAPHelper {
        return shareInstance
    }
    
    func subscriptionSucceed(purchaseCallBack : @escaping (_ isPurchased :Bool) -> Void) {
        self.subscriptionCallBacks.append(purchaseCallBack)
    }
    
    func isSubscribed() -> Bool {
        if ((!IAPHelper.shared().memberShipStatus) || (IAPHelper.shared().userMembershipCheck() != MembershipType.premiumMembership.rawValue)){
            return false
        }
        
        return true
    }
    
    func setupIAP(sharedSecret: String) {
        self.sharedSecret = sharedSecret
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    let downloads = purchase.transaction.downloads
                    if !downloads.isEmpty {
                        SwiftyStoreKit.start(downloads)
                    } else if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                    print("\(purchase.transaction.transactionState.debugDescription): \(purchase.productId)")
                case .failed, .purchasing, .deferred:
                    break // do nothing
                @unknown default:
                    break
                }
            }
            print("setupIAP girdi")
            self.purchaseRestore(completion: nil)
        }
        
        SwiftyStoreKit.updatedDownloadsHandler = { downloads in
            // contentURL is not nil if downloadState == .finished
            let contentURLs = downloads.compactMap { $0.contentURL }
            if contentURLs.count == downloads.count {
                print("Saving: \(contentURLs)")
                SwiftyStoreKit.finishTransaction(downloads[0].transaction)
            }
        }
    }
    
    func purchaseRestore(completion: ((_ message: String, _ purchaseResult: VerifySubscriptionResult?) -> Void)? = nil) {
        SwiftyStoreKit.restorePurchases { (results) in
            
            if results.restoreFailedPurchases.count > 0{
                Logger.error("Restore faild: \(results.restoreFailedPurchases)")
                if let callback = completion{
                    callback("The restore was failed. Please try again later", nil)
                }
            }else if results.restoredPurchases.count > 0{
                print("Restore Success: \(results.restoredPurchases)")
                let productResult = results.restoredPurchases[0]
                let productId = productResult.productId
                self.appleReceiptSubscriptionValidator(iapType: .Restore, productId: productId, completion: completion)
            }else{
                print("Nothing to Restore")
                if let callback = completion{
                    callback("The restore was failed. Please try again later", nil)
                }
            }
        }
    }
    
    func handlePurchase(product: IAPProduct, completion: ((_ message: String, _ purchaseResult: VerifyPurchaseResult?) -> Void)? = nil)
    {
        let productId = product.skProduct.productIdentifier
        
        SwiftyStoreKit.purchaseProduct(productId, atomically: true) { result in
            print("result=\(result)")
            if case .success(let purchaseProduct) = result {
                // Deliver content from server, then:
                if purchaseProduct.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(purchaseProduct.transaction)
                }
                self.appleReceiptPurchaseValidator(iapType: .Purchase, productId: productId, completion: completion)
            } else {
                if let callback = completion{
                    callback("Purchase handle failed, please try again.", nil)
                }
            }
        }
    }
    
    func handleSubscription(product: IAPProduct, completion: ((_ message: String, _ purchaseResult: VerifySubscriptionResult?) -> Void)? = nil)
    {
        let productId = product.skProduct.productIdentifier
        
        SwiftyStoreKit.purchaseProduct(productId, atomically: true) { result in
            print("result=\(result)")
            if case .success(let purchaseProduct) = result {
                // Deliver content from server, then:
                if purchaseProduct.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(purchaseProduct.transaction)
                }
                self.appleReceiptSubscriptionValidator(iapType: .Purchase, productId: productId, completion: completion)
            } else {
                if let callback = completion{
                    callback("Purchase failed, you may have made a purchase, please restore or try again.", nil)
                }
            }
        }
    }
    
    private func appleReceiptPurchaseValidator(iapType :IAPType, productId: String, completion: ((_ message: String, _ purchaseResult: VerifyPurchaseResult?) -> Void)? = nil){
        var message = ""
        var isPurchased = false
        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: self.sharedSecret)
        SwiftyStoreKit.verifyReceipt(using: appleValidator) { (result) in
            if case .success(let receipt) = result {
                let purchaseResult = SwiftyStoreKit.verifyPurchase(productId: productId, inReceipt: receipt)
                
                switch purchaseResult {
                case .purchased:
                    isPurchased = true
                    self.memberShipStatus = true
                    self.memberShipExpiredDay = "3000-01-01 00:00"      // tránh tình trạng không check được gói non-consumable
                    message = "You have purchased product successfully."
                case .notPurchased:
                    isPurchased = false
                    message = "You did not purchase any product."
                }
                
                for callback in self.subscriptionCallBacks{
                    callback(isPurchased)
                }
                
                completion?(message, purchaseResult)
            }else{
                // receipt verification error
                completion?("Cannot connect to iTunes Store. Please try again!", nil)
            }
        }
    }
    
    private func appleReceiptSubscriptionValidator(iapType: IAPType, productId: String, completion: ((_ message: String, _ purchaseResult: VerifySubscriptionResult?) -> Void)? = nil) {
        
        // get the receipt from SwiftyStoreKit and validate
        if let receiptData = SwiftyStoreKit.localReceiptData {
            do {
                let receipt = try InAppReceipt.receipt(from: receiptData)
                validateReceipt(receipt: receipt,iapType: iapType, completion: completion)
            }
            catch {
                // error creating receipt from data?
                completion?("Error validating local receipt", nil)
            }
        }
        else {
            //no receipt, hence force a refresh
            SwiftyStoreKit.fetchReceipt(forceRefresh: true) { result in
                switch result {
                case .success(let receiptData):
                    do {
                        let receipt = try InAppReceipt.receipt(from: receiptData)
                        self.validateReceipt(receipt: receipt,iapType: iapType, completion: completion)
                    }
                    catch {
                        completion?("Error validating receipt", nil)
                    }
                case .error(_):
                    completion?("Error fetching receipt", nil)
                    break
                }
            }
        }
    }
    
    private func validateReceipt(receipt: InAppReceipt, iapType :IAPType , completion: ((_ message: String, _ purchaseResult: VerifySubscriptionResult?) -> Void)? = nil) {
        
        // Verify all at once
        do {
            try receipt.validate()
        } catch IARError.validationFailed(reason: .hashValidation) {
            // Do smth
            completion?("Hash Validation Failed", nil)
        } catch IARError.validationFailed(reason: .bundleIdentifierVerification) {
            // Do smth
            completion?("Bundle Identifier Vefirication Failed", nil)
        } catch IARError.validationFailed(reason: .signatureValidation) {
            // Do smth
            completion?("Signature Validation Failed", nil)
        } catch {
            // Do smth
        }
        
        // Check whether receipt contains any purchases
        let hasPurchases = receipt.hasPurchases
        
        if hasPurchases {
            var isPurchased = false
            var message = ""
            
            if receipt.purchases.first(where: { !$0.isRenewableSubscription}) != nil{
                self.memberShipStatus = true
                self.memberShipExpiredDay = "3000-01-01 00:00"
                message = "You have restored product successfully."
                isPurchased = true
                
                for callback in self.subscriptionCallBacks{
                    callback(isPurchased)
                }
                
                completion?(message, VerifySubscriptionResult.purchased(expiryDate: Date(), items: []))
            } else {
                let activeRenewPurchases: [InAppPurchase] = receipt.activeAutoRenewableSubscriptionPurchases
                if let purchase = activeRenewPurchases.first{
                    
                    self.memberShipStatus = true
                    self.memberShipExpiredDay = IAPFormatter.shared.getStringFromDate(date: purchase.subscriptionExpirationDate!, format: "yyyy-MM-dd HH:mm")
                    switch iapType{
                    case .Restore:
                        message = "You have restored product successfully."
                    case .Purchase:
                        message = "You have purchased product successfully."
                    }
                    isPurchased = true
                    
                    for callback in self.subscriptionCallBacks{
                        callback(isPurchased)
                    }
                    
                    completion?(message, VerifySubscriptionResult.purchased(expiryDate: Date(), items: []))
                } else {
                    message = "Your purchase was expired or you did not purchase any product."
                    for callback in self.subscriptionCallBacks{
                        callback(isPurchased)
                    }
                    completion?(message, VerifySubscriptionResult.notPurchased)
                }
            }
        } else {
            completion?("Error validating local receipt", nil)
        }
        
        // Add your own logic here around exactly what you want to check
    }
    
    // return user membership status after checking membership
    private func userMembershipCheck()  -> String {
        if UserDefaultHelper.shared.preferences?.bool(forKey: USER_MEMBERSIP_PREMIUM_STATUS) ?? false {
            if let expire_date_string = UserDefaultHelper.shared.preferences?.object(forKey: USER_MEMBERSIP_PREMIUM_EXPIRED_DATE) as? String
            {
                let expire_date = IAPFormatter.shared.getDatefromString(strdate: expire_date_string, format: "yyyy-MM-dd HH:mm")
                let current_date = Date()
                if current_date > expire_date
                {
                    return MembershipType.expireMembership.rawValue
                }
                else{
                    return MembershipType.premiumMembership.rawValue
                }
            }
            return MembershipType.noMembership.rawValue
        } else {
            return MembershipType.noMembership.rawValue
        }
    }
}

private enum IAPType {
    case Restore, Purchase
}

private enum MembershipType: String {
    case noMembership = "no_membership"
    case expireMembership = "expire_membership"
    case premiumMembership = "premium_membership"
}
