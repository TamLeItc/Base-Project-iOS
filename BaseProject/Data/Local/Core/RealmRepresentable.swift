//
//  RealmRepresentable.swift
//  BaseProject
//
//  Created by Tam Le on 18/07/2021.
//  Copyright © 2021 Tam Le. All rights reserved.
//

import Foundation

protocol RealmRepresentable {
    associatedtype RealmType: ModelConvertibleType
    
    func asRealm() -> RealmType
}
