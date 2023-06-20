//
//  DependencyInjection.swift
//  i270-locksafe
//
//  Created by Tam Le on 30/03/2023.
//

import Foundation
import Swinject

public class DI {
    
    static let shared = DI()
    
    let container = Container()
    
    private let dbManager = DBManager()
    
    private init() {
        DatabaseModule().register(container: container, config: dbManager.config)
        NetworkModule().register(container: container)
        RepositoryModule().register(container: container)
        ViewModelModule().register(container: container)
        AppModule().register(container: container)
        AdModule().register(container: container)
    }
    
    func resolve<T>() -> T {
        guard let resolvedType = container.resolve(T.self) else {
            fatalError("Failed to resolve \(String(describing: T.self))")
        }
        return resolvedType
    }
}


