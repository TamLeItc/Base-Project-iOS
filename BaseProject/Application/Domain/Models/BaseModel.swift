//
//  BaseModel.swift
//  BaseProject
//
//  Created by Tam Le on 18/07/2021.
//  Copyright © 2021 Tam Le. All rights reserved.
//

import Foundation
import ObjectMapper

class BaseModel: Mappable {
    
    init() {}
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
    }
    
    func properties() -> [(key: String, value: Any)] {
        let mirror = Mirror(reflecting: self)
        
        var retValue = [(key: String, value: Any)]()
        for (_, attr) in mirror.children.enumerated() {
            if let property_name = attr.label as String? {
                retValue.append((key: property_name, value: attr.value))
            }
        }
        return retValue
    }
    
    static func == (lhs: BaseModel, rhs: BaseModel) -> Bool {
        var isEqual = true
        lhs.properties().forEach { lhsItem in
            rhs.properties().forEach { rhsItem in
                if (lhsItem.key == rhsItem.key) {
                    let lhsItemValue = lhsItem.value as? String ?? ""
                    let rhsItemValue = rhsItem.value as? String ?? ""
                    if (lhsItemValue != rhsItemValue) {
                        isEqual = false
                    }
                }
            }
        }
        return isEqual
    }
}
