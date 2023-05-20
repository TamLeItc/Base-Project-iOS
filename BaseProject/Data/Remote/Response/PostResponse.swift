//
//  PostResponse.swift
//  BaseProject
//
//  Created by Tam Le on 08/07/2021.
//  Copyright © 2021 Tam Le. All rights reserved.
//

import ObjectMapper

struct PostResponse: Mappable {
    
    var data: [Post] = []
    
    init?(map: ObjectMapper.Map) {
        
    }
    
    mutating func mapping(map: Map) {
        data <- map["data"]
    }
    
}
