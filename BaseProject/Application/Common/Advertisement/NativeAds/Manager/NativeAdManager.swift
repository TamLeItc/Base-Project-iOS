//
//  NativeAdManager.swift
//  i270-locksafe
//
//  Created by Tam Le on 21/04/2023.
//

import GoogleMobileAds
import RxSwift

protocol NativeAdManager: NativeAdManagerImp {
    func loadAd(_ rootVC: UIViewController, nativeAdId: String)
    func getNativeAds() -> [GADNativeAd]
    func subsNativeAds() -> Observable<[GADNativeAd]>
}
