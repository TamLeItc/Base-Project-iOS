//
//  ApiServiceImp.swift
//
//  Created by Tam Le on 09/07/2021.
//  Copyright © 2021 Tam Le. All rights reserved.
//


import Foundation
import RxSwift
import Moya
import ObjectMapper

final class ApiServiceImp: ApiService {

    @Inject
    var appNetwork: AppNetwork
    
    //MARK: -- Demo
    
    func getPost() -> Single<[Post]> {
        return appNetwork.requestArray(.posts, type: Post.self)
    }
    
    //MARK: App

    
}
