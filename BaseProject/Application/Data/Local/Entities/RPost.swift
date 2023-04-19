//
//  RPost.swift
//
//  Created by Tam Le on 28/03/2023.
//

import Foundation
import RealmSwift
import Realm

class RPost: Object {
    @objc dynamic var userId: Int = 0
    @objc dynamic var id: Int = 0
    @objc dynamic var title: String = ""
    @objc dynamic var body: String = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

extension RPost : ModelConvertibleType {
    var uid: String {
        return String(id)
    }
    
    func asModel() -> Post {
        return Post(userId: userId, id: id, title: title, body: body)
    }
}

extension Post: RealmRepresentable {
    typealias RealmType = RPost
    
    func asRealm() -> RPost {
        return Post.build {
            $0.userId = userId
            $0.id = id
            $0.title = title
            $0.body = body
        }
    }
}
