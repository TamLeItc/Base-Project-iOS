//
//  AppUtils.swift
//  BaseProject
//
//  Created by Tam Le on 7/28/20.
//  Copyright © 2020 Tam Le. All rights reserved.
//

import Foundation
import UIKit
import StoreKit
import AppTrackingTransparency
import AdSupport

class AppUtils {
    static func showVoucherPremium(_ parentVC: UIViewController) {
        let alert = UIAlertController(title: "Enter Premium Code", message: nil, preferredStyle:  .alert)
        alert.addTextField(configurationHandler: {
            $0.keyboardType = .numberPad
        })
        
        let submitAction = UIAlertAction(title: "Submit", style: .default, handler: { _ in
            let pinCode = alert.textFields![0].text ?? ""
            if pinCode == "132978" {
                IAPHelper.shared().memberShipStatus = true
                IAPHelper.shared().memberShipExpiredDay = "3000-01-01 00:00"
                parentVC.showToast(message: "Success. Restart app to use premium.")
            } else {
                parentVC.showToast(message: "Error. Voucher not found.")
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        alert.addAction(cancelAction)
        alert.addAction(submitAction)
        parentVC.present(alert, animated: true)
    }
    
    static func sendMail(subject: String, body: String) {
        let emailString = "mailto:\(Configs.InfoApp.email)?subject=\(subject)&body=\(body)"
        
        if let mailURL = URL(string: emailString) {
            if UIApplication.shared.canOpenURL(mailURL) {
                UIApplication.shared.open(mailURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    static func openAppStore() {
        if let url = URL(string: "itms-apps://itunes.apple.com/app/\(Configs.InfoApp.appId)"),
           UIApplication.shared.canOpenURL(url){
            UIApplication.shared.open(url, options: [:]) { (opened) in
                if(opened){
                    print("App Store Opened")
                }
            }
        } else {
            print("Can't Open URL on Simulator")
        }
    }
    
    static func openReviewAppInStore() {
        if let url = URL(string: "itms-apps://itunes.apple.com/app/\(Configs.InfoApp.appId)?action=write-review"),
           UIApplication.shared.canOpenURL(url){
            UIApplication.shared.open(url, options: [:]) { (opened) in
                if(opened){
                    Logger.error("App Store Opened")
                }
            }
        } else {
            Logger.error("Can't Open URL on Simulator")
        }
    }
    
    static func goToAppSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    static func rateForApp(){
        if !ConnectionHelper.shared.isInternetAvailable() {
            return
        }
        if #available(iOS 14.0, *) {
            if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                SKStoreReviewController.requestReview(in: scene)
            }
        } else {
            SKStoreReviewController.requestReview()
        }
    }
    
    static func openURL(_ parentVC: UIViewController, url: URL, onCompleted: (() -> Void)? = nil) {
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    static func shareURL(_ parentVC: UIViewController, url: URL, onCompleted: (() -> Void)? = nil) {
        let activity = UIActivityViewController(activityItems: [Bundle.main.displayName, url], applicationActivities: nil)
        if UIDevice.isPad {
            activity.popoverPresentationController?.sourceView = parentVC.view
        }
        activity.excludedActivityTypes = [.airDrop, .addToReadingList, .copyToPasteboard]
        parentVC.present(activity, animated: true, completion: {
            onCompleted?()
        })
    }
    
    static func requestIDFA(_ onCompleted: (() -> Void)? = nil) {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                switch status {
                case .denied:
                    print("Tracking denied")
                case .notDetermined:
                    print("Tracking notDetermined")
                case .restricted:
                    print("Tracking restricted")
                case .authorized:
                    print("Tracking authorized")
                @unknown default:
                    break
                }
                onCompleted?()
            })
        } else {
            onCompleted?()
        }
    }
}

extension AppUtils {
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        AppDelegate.shared().orientationLock = orientation
    }
    
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
        self.lockOrientation(orientation)
        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
    }
}
