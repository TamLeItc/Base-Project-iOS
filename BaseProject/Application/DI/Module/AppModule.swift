//
//  AppModule.swift
//  BaseProject
//
//  Created by Tam Le on 19/04/2023.
//

import Foundation
import Swinject
import Realm
import RealmSwift

final class AppModule {
    
    func register(container: Container) {
        container.register(AppDataSource.self) { _ in AppDataSourceImp() }
        container.register(EventLogger.self) { _ in EventLoggerImp() }
        container.register(RemoteConfigManager.self) { _ in RemoteConfigManagerImp() }
    }
    
}
