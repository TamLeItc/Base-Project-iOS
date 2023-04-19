//
//  Resolver.swift
//  i270-locksafe
//
//  Created by Tam Le on 30/03/2023.
//

import Swinject

extension Resolver {
    public func resolve<T>() -> T {
        guard let resolvedType = resolve(T.self) else {
            fatalError("Failed to resolve \(String(describing: T.self))")
        }
        
        return resolvedType
    }
}
