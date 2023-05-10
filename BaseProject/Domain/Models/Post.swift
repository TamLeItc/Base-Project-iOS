//
//  Organization.swift
//  baseproject
//
//  Created by Tam Le on 28/03/2023.
//

import Foundation
import ObjectMapper

final class Post : BaseModel {
    var userId: Int = 0
    var id: Int = 0
    var title: String = ""
    var body: String = ""
    
    init(userId: Int, id: Int, title: String, body: String) {
        super.init()
        self.userId = userId
        self.id = id
        self.title = title
        self.body = body
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        userId <- map["userId"]
        id <- map["id"]
        title <- map["title"]
        body <- map["body"]
    }
}
