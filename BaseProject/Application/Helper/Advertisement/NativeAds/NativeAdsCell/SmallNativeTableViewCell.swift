//
//  SmallNativeTableViewCell.swift
//  Super minecraft
//
//  Created by Petrus on 3/23/20.
//  Copyright © 2020 Foxcode. All rights reserved.
//

import UIKit
import GoogleMobileAds
import MaterialComponents.MaterialCards

class SmallNativeTableViewCell: BaseTableViewCell {
    
    @IBOutlet weak var adLabel: UILabel!
    @IBOutlet weak var cardView: MDCCard!
    @IBOutlet weak var nativeAdView: GADNativeAdView!
    
    override func setup() {
        backgroundColor = .clear
        
        adLabel.letIt {
            $0.backgroundColor = .systemYellow
            $0.textColor = .white
            $0.font = UIFont(name: "Poppins-Regular", size: 11)
            $0.cornerRadius = 4
        }
        
        nativeAdView.backgroundColor = .clear
        
        cardView.letIt {
            $0.backgroundColor = Theme.Colors.primary
            $0.layer.cornerRadius = 12
            $0.setShadowColor(.clear, for: .normal)
        }
        
        (nativeAdView.headlineView as? UILabel).map({
            $0.textColor = Theme.Colors.textPrimary
            $0.font = UIFont(name: "Poppins-Medium", size: 15)
        })
        
        (nativeAdView.advertiserView as? UILabel).map({
            $0.textColor = UIColor(hex: 0x858585)
            $0.font = UIFont(name: "Poppins-Regular", size: 14)
        })
        
        (nativeAdView.bodyView as? UILabel).map({
            $0.textColor = UIColor(hex: 0x858585)
            $0.font = UIFont(name: "Poppins-Regular", size: 13)
        })
        
        (nativeAdView.callToActionView as? UIButton).map {
            $0.backgroundColor = .clear
            $0.setTitleColor(Theme.Colors.primary, for: .normal)
            $0.titleLabel?.font = UIFont(name: "Poppins-Medium", size: 13)
            $0.cornerRadius = 8
            $0.borderWidth = 1
            $0.borderColor = Theme.Colors.primary
        }
        
        nativeAdView.iconView?.cornerRadius = 16
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
