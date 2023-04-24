//
//  MergeItemAds.swift
//  BaseProject
//
//  Created by Tam Le on 10/24/20.
//  Copyright © 2020 Tam Le. All rights reserved.
//

import GoogleMobileAds
import RxRelay
import RxSwift
import RxDataSources

//MARK: -- ItemOrAd

enum ItemOrAd<T> {
    case item(T)
    case ad(GADNativeAd, position: Int)
}

extension ItemOrAd: Equatable where T: Equatable { }

extension ItemOrAd: IdentifiableType where T: IdentifiableType, T.Identity == String {
    var identity: String {
        switch self {
        case .item(let t):
            return t.identity
        case .ad(let ad, let position):
            return String(describing: ad) + "#\(position)"
        }
    }
}

struct MergeOffset {
    let pad: Int
    let phone: Int
}

//MARK: -- ItemOrAd merge

func mergeData<T>(_ data: [T], with ads: [GADNativeAd], offset: Int = Configs.Advertisement.offsetNativeAdsAndItem) -> [ItemOrAd<T>] {
    if !AdManager.canShowAds || ads.isEmpty {
        let merged: [ItemOrAd<T>] = data.map { .item($0) }
        return merged
    }
    
    guard !data.isEmpty else {
        return []
    }
    
    let totalAdsNeeded = data.count / 2
    let numberOfSegments = Int((Double(totalAdsNeeded) / Double(ads.count)).rounded(.up))
    let totalAds = Array(Array(repeating: ads, count: numberOfSegments).flatMap { $0 }.prefix(totalAdsNeeded))
    
    var merged: [ItemOrAd<T>] = []
    merged.reserveCapacity(totalAds.count + data.count)
    merged.append(.item(data[0]))
    
    var adIndex = 0
    var itemIndex = 1
    while itemIndex < data.count, adIndex < totalAds.count {
        if (merged.count + 1) % offset == 0 {
            let ad = totalAds[adIndex]
            merged.append(.ad(ad, position: adIndex))
            adIndex += 1
        } else {
            let item = data[itemIndex]
            merged.append(.item(item))
            itemIndex += 1
        }
    }
    
    while itemIndex < data.count {
        let item = data[itemIndex]
        merged.append(.item(item))
        itemIndex += 1
    }
    
    if merged.count % offset == 0, adIndex < totalAds.count {
        let ad = totalAds[adIndex]
        merged.append(.ad(ad, position: adIndex))
    }
    
    merged.insert(.ad(ads[0], position: 0), at: 0)
    
    return merged
}
