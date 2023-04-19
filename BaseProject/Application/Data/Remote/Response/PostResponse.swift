//
//  PostResponse.swift
//  BaseProject
//
//  Created by Tam Le on 08/07/2021.
//  Copyright © 2021 Tam Le. All rights reserved.
//

import Foundation
import ObjectMapper

final class PostResponse: BaseResponse {
    var data: [Post] = []
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        data <- map["data"]
    }
    
}
