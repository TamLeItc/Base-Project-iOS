//
//  RemoteConfigManagerImp.swift
//  BaseProject
//
//  Created by Tam Le on 19/04/2023.
//

import Foundation
import FirebaseRemoteConfig

enum RemoteConfigKey: String {
    case AdjustTokenKey = "LockSafe_AdjustTokenKey"
    case AdjustTokenPurchaseKey = "LockSafe_AdjustTokenPurchaseKey"
}

enum RemoteConfigDefault {
    static let adjustToken: NSString = "qubo199o01kw"
    static let adjustTokenPurchase: NSString = "95sjb9"
}

class RemoteConfigManagerImp: RemoteConfigManager {
    
    private var remoteConfig: RemoteConfig? = nil
    
    private var remoteConfigFetched = false
    
    func fetchConfig(_ onCompleted: (() -> Void)?) {
        
        if (remoteConfigFetched) {
            return
        }
        remoteConfigFetched = true
        
        remoteConfig = RemoteConfig.remoteConfig()
        setDefaultValue()
        
        remoteConfig?.fetch() { status, error in
            if status == .success {
                
            } else {
                print("RemoteConfigHelper: Config Not Fetched")
            }
            self.remoteConfig?.activate(completion: nil)
            self.printRemoteValue()
            onCompleted?()
        }
    }
    
    func getStringValue(fromKey key: RemoteConfigKey) -> String {
        return remoteConfig?.configValue(forKey: key.rawValue).stringValue ?? ""
    }
    
    func getNumberValue(fromKey key: RemoteConfigKey) -> NSNumber {
        return remoteConfig?.configValue(forKey: key.rawValue).numberValue ?? 0
    }
    
    private func setDefaultValue() {
        remoteConfig?.setDefaults([
            RemoteConfigKey.AdjustTokenKey.rawValue: RemoteConfigDefault.adjustToken,
            RemoteConfigKey.AdjustTokenPurchaseKey.rawValue: RemoteConfigDefault.adjustTokenPurchase,
        ])
    }
    
    private func printRemoteValue() {
        print("RemoteConfigHelper: { key: \(RemoteConfigKey.AdjustTokenKey.rawValue), value: \(getStringValue(fromKey: .AdjustTokenKey)) }")
        print("RemoteConfigHelper: { key: \(RemoteConfigKey.AdjustTokenPurchaseKey.rawValue), value: \(getStringValue(fromKey: .AdjustTokenPurchaseKey)) }")
    }
}
