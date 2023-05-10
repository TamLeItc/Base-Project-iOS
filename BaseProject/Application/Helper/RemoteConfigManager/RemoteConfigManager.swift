//
//  RemoteConfigManager.swift
//  BaseProject
//
//  Created by Tam Le on 19/04/2023.
//

import Foundation

protocol RemoteConfigManager {
    func fetchConfig(_ onCompleted: (() -> Void)?)
    func getStringValue(fromKey key: RemoteConfigKey) -> String
    func getNumberValue(fromKey key: RemoteConfigKey) -> NSNumber
}
