//
//  LocalDataManager.swift
//  BaseProject
//
//  Created by Tam Le on 18/07/2021.
//  Copyright © 2021 Tam Le. All rights reserved.
//

import Foundation
import RxSwift

class LocalRespositoryImp: LocalRespository {
    
    @Inject
    var postDAO: PostDAO
    
    func getPosts() -> Observable<[Post]> {
        return postDAO.findAll()
    }
    
    func addSite(post: Post) -> RxSwift.Observable<Post> {
        return postDAO.save(post.asRealm())
    }
    
    func delete(withId id: Int) -> Observable<Void> {
        return postDAO.delete(withId: id)
    }
    
    func deleteAll() -> RxSwift.Observable<Void> {
        return postDAO.deleteAll()
    }
}
