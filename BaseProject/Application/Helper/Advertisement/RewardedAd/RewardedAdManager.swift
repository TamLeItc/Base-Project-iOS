//
//  RewardedAd.swift
//  i270-locksafe
//
//  Created by Tam Le on 24/04/2023.
//

import UIKit
import GoogleMobileAds

protocol RewardedAdManager {
    func initWith(_ adId: String)
    func showAd(
        _ viewController: UIViewController,
        onAdClosed: ((_ reward: GADAdReward?) -> Void)?,
        onPresentFailed: (() -> Void)?
    )
}
