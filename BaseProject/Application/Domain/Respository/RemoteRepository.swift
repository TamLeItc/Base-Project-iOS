//
//  RemoteRepository.swift
//  BaseProject
//
//  Created by Tam Le on 20/07/2021.
//  Copyright © 2021 Tam Le. All rights reserved.
//

import Foundation
import RxSwift

protocol RemoteRepository {
    //Demo
    func getPosts() -> Single<[Post]>
    
    //App
}
