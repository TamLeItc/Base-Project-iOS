//
//  BaseResponse.swift
//  BaseProject
//
//  Created by Tam Le on 08/07/2021.
//  Copyright © 2021 Tam Le. All rights reserved.
//

import Foundation
import ObjectMapper

class BaseResponse : Mappable {
    var message: String = ""
    var status: Int = 0
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        message <- map["message"]
        status <- map["status"]
    }
    
}
