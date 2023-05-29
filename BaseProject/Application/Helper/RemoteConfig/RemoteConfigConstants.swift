//
//  Constants.swift
//  BaseProject
//
//  Created by Tam Le on 29/05/2023.
//

import Foundation

enum RemoteConfigKey: String {
    case AdjustTokenKey = "LockSafe_AdjustTokenKey"
    case AdjustTokenPurchaseKey = "LockSafe_AdjustTokenPurchaseKey"
}

enum RemoteConfigDefault {
    static let adjustToken: NSString = "qubo199o01kw"
    static let adjustTokenPurchase: NSString = "95sjb9"
}
