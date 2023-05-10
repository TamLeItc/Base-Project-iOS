//
//  DBManager.swift
//  BaseProject
//
//  Created by Tam Le on 18/07/2021.
//  Copyright © 2021 Tam Le. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

private let dbVersion : UInt64 = 1
private let dbName = "base_project"

final class DBManager {
    
    var config: Realm.Configuration!
    
    init() {
        
        config = Realm.Configuration(
            schemaVersion: dbVersion,
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 1 {
                    //MARK: migrate db here
                }
            }
        )
        Realm.Configuration.defaultConfiguration = config
    }
}
