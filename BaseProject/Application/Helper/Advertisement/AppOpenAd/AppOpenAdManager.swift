//
//  AppOpenAdManager.swift
//  i270-locksafe
//
//  Created by Tam Le on 24/04/2023.
//

import UIKit

protocol AppOpenAdManager {
    func initWith(_ adId: String)
    func tryToPresentAd(
        _ rootController: UIViewController?,
        onCompleted: (() -> Void)?
    )
}
