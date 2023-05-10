//
//  BaseDaoService.swift
//  BaseProject
//
//  Created by Tam Le on 20/07/2021.
//  Copyright © 2021 Tam Le. All rights reserved.
//

import Foundation
import RealmSwift

protocol BaseDaoService {
    var realm: Realm { get }
    func writeObject(executeCode: () -> ())
}
