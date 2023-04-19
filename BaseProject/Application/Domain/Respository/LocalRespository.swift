//
//  LocalImp.swift
//  BaseProject
//
//  Created by Tam Le on 18/07/2021.
//  Copyright © 2021 Tam Le. All rights reserved.
//

import Foundation
import RxSwift

protocol LocalRespository {
    func getPosts() -> Observable<[Post]>
    func addSite(post: Post) -> Observable<Post>
    func delete(withId id: Int) -> Observable<Void>
    func deleteAll() -> Observable<Void>
}
