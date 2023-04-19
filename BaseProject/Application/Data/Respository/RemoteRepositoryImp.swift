//
//  RepositoryImp.swift
//  BaseProject
//
//  Created by Tam Le on 09/07/2021.
//  Copyright © 2021 Tam Le. All rights reserved.
//

import Foundation
import RxSwift
import RxSwiftExt

final class RemoteRepositoryImp: RemoteRepository {
    
    @Inject
    var apiService: ApiService!
    
    func getPosts() -> Single<[Post]> {
        return apiService.getPost()
    }
}
