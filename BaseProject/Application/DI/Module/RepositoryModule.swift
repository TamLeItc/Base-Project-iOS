//
//  RepositoryModule.swift
//  i270-locksafe
//
//  Created by Tam Le on 30/03/2023.
//

import Foundation
import Swinject

final class RepositoryModule {
    
    func register(container: Container) {
        container.register(LocalRespository.self) { _ in LocalRespositoryImp()}
        container.register(RemoteRepository.self) { _ in RemoteRepositoryImp() }
    }
}
