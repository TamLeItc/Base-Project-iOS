//
//  IAPProduct.swift
//  BaseProject
//
//  Created by Tam Le on 7/29/20.
//  Copyright © 2020 Tam Le. All rights reserved.
//

import Foundation

import Foundation
import StoreKit

class IAPProduct{
    
    var index: Int = -1
    var skProduct :SKProduct!
    var isSelected: Bool! = false
    var name: String = ""
    var type :ProductType!
    
    convenience init(skProduct :SKProduct, isSelected :Bool) {
        self.init()
        self.skProduct  = skProduct
        self.isSelected = isSelected
    }
}

extension SKProduct{
    func toProduct() -> IAPProduct{
        let iapProduct = IAPProduct(skProduct: self, isSelected: false)
        return iapProduct
    }
}

struct IAPProductContants {
    static var productSelected: IAPProduct!
}
