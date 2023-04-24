//
//  IntersAdManager.swift
//  i270-locksafe
//
//  Created by Tam Le on 24/04/2023.
//

import UIKit

protocol IntersAdManager {
    func initWith(_ adId: String, timeDelayForNextShow: TimeInterval)
    func showAd(_ viewController: UIViewController, onCompleted: (() -> Void)?)
}
