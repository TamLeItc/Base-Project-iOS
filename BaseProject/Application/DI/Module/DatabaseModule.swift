//
//  DatabaseModule.swift
//  i270-locksafe
//
//  Created by Tam Le on 31/03/2023.
//

import Foundation
import Swinject
import Realm
import RealmSwift

final class DatabaseModule {
    
    func register(container: Container, config: Realm.Configuration!) {
        container.register(PostDAO.self) { _ in PostDAOImp(config: config) }
    }
    
}
