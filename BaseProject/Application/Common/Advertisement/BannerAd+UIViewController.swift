//
//  UIViewController+BannerView.swift
//  BaseProject
//
//  Created by Tam Le on 11/12/2021.
//  Copyright © 2021 Tam Le. All rights reserved.
//

import Foundation
import GoogleMobileAds

extension UIViewController {
    func removeBannerView(_ bannerView: GADBannerView, topView: UIView) {
        removeBannerView(bannerView, topViews: [topView])
    }
    
    func removeBannerView(_ bannerView: GADBannerView, topViews: [UIView] = []) {
        bannerView.gone()
        
        topViews.forEach { topView in
            if let supper = topView.superview {
                supper.constraints.forEach { const in
                    if (const.firstAnchor == topView.bottomAnchor) {
                        const.isActive = false
                    }
                }
                topView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
            }
        }
    }
}

extension UIViewController: GADBannerViewDelegate {
    
    func addAdmobBanner(topView: UIView, adSize: GADAdSize? = nil) -> GADBannerView
    {
        return addAdmobBanner(topViews: [topView], adSize: adSize)
    }
    
    
    func addAdmobBanner(topViews: [UIView], adSize: GADAdSize? = nil) -> GADBannerView
    {
        let bannerView = GADBannerView()
        bannerView.adUnitID = Configs.Advertisement.admobBannerId
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
            if AdManager.canShowAds {
                if adSize != nil {
                    bannerView.adSize = adSize!
                } else {
                    bannerView.adSize = self.getSmartBannerSize()
                }
                self.addBannerViewToView(bannerView, views: topViews)
                bannerView.rootViewController = self
                bannerView.delegate = self
                bannerView.load(GADRequest())
            }
        })
        return bannerView
    }
    
    func addAdmobBanner(to bannerView: GADBannerView) {
        bannerView.backgroundColor = .clear
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
            if AdManager.canShowAds {
                bannerView.adUnitID = Configs.Advertisement.admobBannerId
                bannerView.rootViewController = self
                bannerView.delegate = self
                bannerView.load(GADRequest())
            }
        })
    }
    
    private func getSmartBannerSize() -> GADAdSize {
        let frame = { () -> CGRect in
            // Here safe area is taken into account, hence the view frame is used
            // after the view has been laid out.
            if #available(iOS 11.0, *) {
                return view.frame.inset(by: view.safeAreaInsets)
            } else {
                return view.frame
            }
        }()
        let viewWidth = frame.size.width
        
        // Step 3 - Get Adaptive GADAdSize and set the ad view.
        // Here the current interface orientation is used. If the ad is being preloaded
        // for a future orientation change or different orientation, the function for the
        // relevant orientation should be used.
        return GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)
    }
    
    private func addBannerViewToView(_ bannerView: UIView, views: [UIView]) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(bannerView)
        if #available(iOS 11.0, *) {
            positionBannerAtBottomOfSafeArea(bannerView, topViews: views)
        }
        else {
            positionBannerAtBottomOfView(bannerView, topViews: views)
        }
    }
    
    @available (iOS 11, *)
    private func positionBannerAtBottomOfSafeArea(_ bannerView: UIView, topViews: [UIView]){
        // Position the banner. Stick it to the bottom of the Safe Area.
        // Centered horizontally.
        let guide: UILayoutGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate(
            [bannerView.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
             bannerView.bottomAnchor.constraint(equalTo: guide.bottomAnchor)]
        )
        
        // push up topview 50px
        for topView in topViews{
            topView.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -(bannerView.frame.height + 5)).isActive = true
        }
    }
    
    private func positionBannerAtBottomOfView(_ bannerView: UIView, topViews: [UIView]) {
        // Center the banner horizontally.
        view.addConstraint(NSLayoutConstraint(item: bannerView,
                                              attribute: .centerX,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .centerX,
                                              multiplier: 1,
                                              constant: 0))
        // Lock the banner to the top of the bottom layout guide.
        view.addConstraint(NSLayoutConstraint(item: bannerView,
                                              attribute: .bottom,
                                              relatedBy: .equal,
                                              toItem: self.view.safeAreaLayoutGuide.bottomAnchor,
                                              attribute: .top,
                                              multiplier: 1,
                                              constant: 0))
        // push up topview 50 px
        for topView in topViews{
            view.addConstraint(NSLayoutConstraint(item: topView,
                                                  attribute: .bottom,
                                                  relatedBy: .equal,
                                                  toItem: self.view.safeAreaLayoutGuide.bottomAnchor,
                                                  attribute: .top,
                                                  multiplier: 1,
                                                  constant: -(bannerView.frame.height + 5)))
        }
    }
    
}

extension UIViewController {
    public func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        
    }
    
    public func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        
    }
}
