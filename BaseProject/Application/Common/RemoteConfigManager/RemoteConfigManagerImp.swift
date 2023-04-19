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
    
    private var remoteConfig: RemoteConfig
    
    init() {
        remoteConfig = RemoteConfig.remoteConfig()
        setDefaultValue()
    }
    
    func fetchConfig(_ onCompleted: (() -> Void)?) {
        remoteConfig = RemoteConfig.remoteConfig()
        remoteConfig.fetch() { status, error in
            if status == .success {
                self.remoteConfig.activate(completion: nil)
                self.printRemoteValue()
            } else {
                print("RemoteConfigHelper: Config Not Fetched")
            }
            onCompleted?()
        }
    }
    
    func getStringValue(fromKey key: RemoteConfigKey) -> String {
        return remoteConfig.configValue(forKey: key.rawValue).stringValue ?? ""
    }
    
    func getNumberValue(fromKey key: RemoteConfigKey) -> NSNumber {
        return remoteConfig.configValue(forKey: key.rawValue).numberValue
    }
    
    private func setDefaultValue() {
        remoteConfig.setDefaults([
            RemoteConfigKey.AdjustTokenKey.rawValue: RemoteConfigDefault.adjustToken,
            RemoteConfigKey.AdjustTokenPurchaseKey.rawValue: RemoteConfigDefault.adjustTokenPurchase,
        ])
    }
    
    private func printRemoteValue() {
        print("RemoteConfigHelper: { key: \(RemoteConfigKey.AdjustTokenKey.rawValue), value: \(getStringValue(fromKey: .AdjustTokenKey)) }")
        print("RemoteConfigHelper: { key: \(RemoteConfigKey.AdjustTokenPurchaseKey.rawValue), value: \(getStringValue(fromKey: .AdjustTokenPurchaseKey)) }")
    }
}
