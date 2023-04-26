//
//  SharePrefUtil.swift
//  BaseProject
//
//  Created by Tam Le on 7/28/20.
//  Copyright © 2020 Tam Le. All rights reserved.
//

import Foundation

private enum UserDefaultKey {
    static let firstOpenApp = "firstOpenApp"
    static let hourToPushLocalNoti = "hourToPushLocalNoti"
    static let apiToken = "apiToken"
    static let isReviewed = "isReviewed"
}

class UserDefaultHelper {
    
    static let shared = UserDefaultHelper()
    
    let preferences = UserDefaults(suiteName: Configs.InfoApp.appGroup)
    
    var apiToken: String {
        set(newValue) {
            preferences!.set(newValue, forKey: UserDefaultKey.apiToken)
        }
        get {
            return value(forKey: UserDefaultKey.apiToken) ?? "a7a9203b2b770edde2c069ee03055f91"
        }
    }

    var hourToPushLocalNoti: Int {
        set(newValue) {
            preferences!.set(newValue, forKey: UserDefaultKey.hourToPushLocalNoti)
        }
        get {
            return value(forKey: UserDefaultKey.hourToPushLocalNoti) ?? 0
        }
    }
    
    var isReviewed: Bool {
        set(newValue) {
            preferences!.set(newValue, forKey: UserDefaultKey.isReviewed)
        }
        get {
            return value(forKey: UserDefaultKey.isReviewed) ?? false
        }
    }
}

extension UserDefaultHelper {
    private func value<T>(forKey: String) -> T? {
        return preferences!.value(forKey: forKey) as? T
    }

}
