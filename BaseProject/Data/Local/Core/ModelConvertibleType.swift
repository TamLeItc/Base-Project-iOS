//
//  ModelConvertibleType.swift
//  BaseProject
//
//  Created by Tam Le on 18/07/2021.
//  Copyright © 2021 Tam Le. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

protocol ModelConvertibleType {
    associatedtype ModelType
    associatedtype KeyType
    
    var uid: KeyType { get }
    
    func asModel() -> ModelType
}

extension RealmRepresentable {
    static func build<O: Object>(_ builder: (O) -> Void) -> O {
        let object = O()
        builder(object)
        return object
    }
}
