//
//  IAPSKProduct.swift
//  BaseProject
//
//  Created by Tam Le on 7/29/20.
//  Copyright © 2020 Tam Le. All rights reserved.
//

import Foundation

import Foundation

enum ProductType{
    case autoRenewable
    case nonRenewing
    case nonConsumable
}

struct IAPSKProduct :Hashable{
    var name :String!
    var id :String!
    var type :ProductType!
}
