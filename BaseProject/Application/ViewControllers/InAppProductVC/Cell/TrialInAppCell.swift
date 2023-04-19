//
//  InAppCell.swift
//  SpeedTest
//
//  Created by Tam Le on 22/08/2022.
//  Copyright © 2022 Tam Le. All rights reserved.
//

import UIKit

class TrialInAppCell: BaseTableViewCell {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet weak var freeTrialLabel: UILabel!
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
        
        freeTrialLabel.addDropShadow(shadowRadius: 2, offset: CGSize(width: 1, height: 1), color: UIColor.init(hex: 0x196653, alpha: 0.6))
        freeTrialLabel.layer.masksToBounds = false
        freeTrialLabel.layer.shadowOpacity = 0
    }

    func configure(_ item: IAPProduct) {
        let freeTrialDays = item.skProduct.introductoryPrice!.subscriptionPeriod.numberOfUnits
        let freeTrialText = String(format: "days_free_trial".localized, freeTrialDays)
        
        priceFormatter.locale = item.skProduct.priceLocale
        let price = (priceFormatter.string(from: item.skProduct.price) ?? "") + "/" + item.name.lowercased()
        let priceText = String(format: "price_free_trial".localized, price)
        
        let mutableString = NSMutableAttributedString(string: priceText, attributes: [NSAttributedString.Key.font: Theme.Fonts.regular.with(16)!])
        mutableString.addAttribute(NSAttributedString.Key.font, value: Theme.Fonts.bold.with(18)!, range: NSRange(location: 5, length: price.length))
        
        freeTrialLabel.text = freeTrialText
        priceLabel.attributedText = mutableString
        
        if (item.isSelected) {
            gradientView.startColor = UIColor(hex: 0x05DEFB)
            gradientView.endColor = UIColor(hex: 0x00E5AC)
            
            freeTrialLabel.textColor = .white
            priceLabel.textColor = UIColor(hex: 0x196653)
            
            mainView.layer.shadowOpacity = 1
            freeTrialLabel.layer.shadowOpacity = 1
        } else {
            gradientView.startColor = UIColor(hex: 0x242E33)
            gradientView.endColor = UIColor(hex: 0x242E33)
            
            freeTrialLabel.textColor = UIColor(hex: 0x196653)
            priceLabel.textColor = UIColor(hex: 0xAAB2AE)
            
            mainView.layer.shadowOpacity = 0
            freeTrialLabel.layer.shadowOpacity = 0
        }
    }
    
    
}
