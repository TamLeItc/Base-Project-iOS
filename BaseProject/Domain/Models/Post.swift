//
//  Organization.swift
//  baseproject
//
//  Created by Tam Le on 28/03/2023.
//

import Foundation
import ObjectMapper

final class Post : Mappable {
    var userId: Int = 0
    var id: Int = 0
    var title: String = ""
    var body: String = ""
    
    init(userId: Int, id: Int, title: String, body: String) {
        self.userId = userId
        self.id = id
        self.title = title
        self.body = body
    }
    
    init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        userId <- map["userId"]
        id <- map["id"]
        title <- map["title"]
        body <- map["body"]
    }
}

//struct Post: Mappable {
//    var userId: Int = 0
//    var id: Int = 0
//    var title: String = ""
//    var body: String = ""
//
//    init?(map: ObjectMapper.Map) {
//
//    }
//
//    init(userId: Int, id: Int, title: String, body: String) {
//        self.userId = userId
//        self.id = id
//        self.title = title
//        self.body = body
//    }
//
//    mutating func mapping(map: Map) {
//        userId <- map["userId"]
//        id <- map["id"]
//        title <- map["title"]
//        body <- map["body"]
//    }
//}
