//
//  NormalInAppCell.swift
//  SpeedTest
//
//  Created by Tam Le on 22/08/2022.
//  Copyright © 2022 Tam Le. All rights reserved.
//

import UIKit

class NormalInAppCell: BaseTableViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var priceLabel: UILabel!
    
    let priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.formatterBehavior = .behavior10_4
        formatter.numberStyle = .currency
        return formatter
    }()
    
    override func setup() {
        super.setup()
        
        selectedColor = .clear
        
        mainView.addDropShadow(shadowRadius: 8, offset: CGSize(width: 0, height: 4), color: UIColor(hex: 0xFFBF00, alpha: 0.3))
        mainView.layer.shadowOpacity = 0
        
        priceView.addDropShadow(shadowRadius: 6, offset: CGSize(width: 2, height: 3), color: UIColor(hex: 0x142027))
    }
    
    func configure(_ item: IAPProduct) {
        if (item.type == .nonConsumable) {
            titleLabel.text = "lifetime".localized
            descriptionLabel.text = "for_a_lifetime".localized
        } else {
            titleLabel.text = item.name + "ly"
            descriptionLabel.text = "save_off".localized
        }
        
        priceFormatter.locale = item.skProduct.priceLocale
        priceLabel.text = priceFormatter.string(from: item.skProduct.price)
        
        if (item.isSelected) {
            gradientView.startColor = UIColor(hex: 0x05DEFB)
            gradientView.endColor = UIColor(hex: 0x00E5AC)
            
            titleLabel.textColor = .white
            priceLabel.textColor = UIColor(hex: 0x196653)
            descriptionLabel.textColor = UIColor(hex: 0x196653)
            
            priceView.borderWidth = 0
            priceView.backgroundColor = .white
            
            mainView.layer.shadowOpacity = 1
            priceView.layer.shadowOpacity = 0
        } else {
            gradientView.startColor = UIColor(hex: 0x242E33)
            gradientView.endColor = UIColor(hex: 0x242E33)
            
            titleLabel.textColor = UIColor(hex: 0x196653)
            priceLabel.textColor = .white
            descriptionLabel.textColor = UIColor(hex: 0xAAB2AE)
            
            priceView.borderWidth = 1
            priceView.backgroundColor = UIColor(hex: 0x242E33)
            
            mainView.layer.shadowOpacity = 0
            priceView.layer.shadowOpacity = 1
        }
    }
    
}
