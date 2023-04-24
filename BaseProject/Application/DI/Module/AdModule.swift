//
//  AdModule.swift
//  BaseProject
//
//  Created by Tam Le on 24/04/2023.
//

import Foundation
import Swinject

final class AdModule {
    func register(container: Container) {
        container.register(AppOpenAdManager.self) { _ in AppOpenAdManagerImp() }
        container.register(NativeAdManager.self) { _ in NativeAdManagerImp() }
        container.register(IntersAdManager.self) { _ in IntersAdManagerImp() }
        container.register(RewardedAdManager.self) { _ in RewardedAdManagermp() }
    }
}
