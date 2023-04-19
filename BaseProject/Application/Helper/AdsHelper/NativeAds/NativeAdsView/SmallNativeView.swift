//
//  SmallNativeView.swift
//  ModMarker
//
//  Created by Tam Le on 07/04/2021.
//  Copyright © 2021 Tam Le. All rights reserved.
//

import UIKit
import GoogleMobileAds
import MaterialComponents.MaterialCards

class SmallNativeView: UIView {
    
    @IBOutlet weak var cardView: MDCCard!
    @IBOutlet weak var nativeAdView: GADNativeAdView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func setup(_ clearBackgroundButton: Bool) {
        backgroundColor = .clear
        nativeAdView.backgroundColor = .clear
        
        cardView.backgroundColor = .clear
        cardView.layer.cornerRadius = 8
        cardView.setShadowColor(.clear, for: .normal)
        
        if clearBackgroundButton {
            (nativeAdView.callToActionView as? UIButton).map {
                $0.backgroundColor = .clear
                $0.setTitleColor(Theme.Colors.primary, for: .normal)
                $0.layer.cornerRadius = 8
            }
        } else {
            (nativeAdView.callToActionView as? UIButton).map {
                $0.backgroundColor = Theme.Colors.primary
                $0.setTitleColor(.white, for: .normal)
                $0.layer.cornerRadius = 8
            }
        }
    }
    
    func configure(with nativeAd: GADNativeAd) {
        nativeAdView.nativeAd = nativeAd
        
        nativeAdView.mediaView?.mediaContent = nativeAd.mediaContent
        
        (nativeAdView.headlineView as? UILabel)?.text = nativeAd.headline
        
        (nativeAdView.bodyView as? UILabel)?.text = nativeAd.body
        nativeAdView.bodyView?.isHidden = nativeAd.body == nil
        
        (nativeAdView.callToActionView as? UIButton)?.setTitle(nativeAd.callToAction, for: .normal)
        nativeAdView.callToActionView?.isHidden = nativeAd.callToAction == nil
        
        (nativeAdView.iconView as? UIImageView)?.image = nativeAd.icon?.image
        nativeAdView.iconView?.isHidden = nativeAd.icon == nil
        
        (nativeAdView.storeView as? UILabel)?.text = nativeAd.store
        nativeAdView.storeView?.isHidden = nativeAd.store == nil
        
        (nativeAdView.priceView as? UILabel)?.text = nativeAd.price
        nativeAdView.priceView?.isHidden = nativeAd.price == nil
        
        (nativeAdView.advertiserView as? UILabel)?.text = nativeAd.advertiser
        nativeAdView.advertiserView?.isHidden = nativeAd.advertiser == nil
        
        nativeAdView.callToActionView?.isUserInteractionEnabled = false
    }
    
}
