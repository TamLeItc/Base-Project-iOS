//
//  PostDAOImp.swift
//
//  Created by Tam Le on 28/03/2023.
//

import Foundation
import Realm
import RealmSwift
import RxSwift
import RxRealm

class PostDAOImp: BaseDAO, PostDAO {
    
    func findAll() -> Observable<[Post]> {
        return Observable.deferred {
            let realm = self.realm
            let objs = realm
                .objects(RPost.self)
            return Observable.array(from: objs)
                .map { $0.map { $0.asModel() } }
                .map { $0.reversed() }
                .observe(on: self.concurrentScheduler)
        }
    }
    
    func find(withId id: Int) -> Observable<Post?> {
        let predicate = NSPredicate(format: "id == %@", id)
        return Observable.deferred {
            let realm = self.realm
            let obj = realm
                .objects(RPost.self)
                .filter(predicate)
                .first
            return Observable.from(optional: obj)
                .map { $0.asModel() }
                .observe(on: self.concurrentScheduler)
        }
    }
    
    func save(_ entity: RPost) -> Observable<Post> {
        return Observable.deferred {
            let realm = self.realm
            return realm.rx.save(entity).map { $0.asModel() }
        }.observe(on: self.serialScheduler)
    }
    
    func update(_ entity: RPost) -> Observable<Post> {
        return Observable.deferred {
            let realm = self.realm
            return realm.rx.save(entity, update: true).map { $0.asModel() }
        }.observe(on: self.serialScheduler)
    }
    
    func deleteAll() -> Observable<Void> {
        return Observable.deferred {
            self.delete(self.realm
                .objects(RPost.self)
                .toArray())
        }.observe(on: self.serialScheduler)
    }
    
    func delete(withId id: Int) -> Observable<Void> {
        let predicate = NSPredicate(format: "id == %@", id)
        return Observable.deferred {
            self.delete(self.realm
                .objects(RPost.self)
                .filter(predicate)
                .toArray())
        }.observe(on: self.serialScheduler)
    }
    
    func delete(_ entity: RPost) -> Observable<Void> {
        return Observable.deferred {
            return self.realm.rx.delete(entity)
        }.observe(on: self.serialScheduler)
    }
    
    func delete(_ entites: [RPost]) -> Observable<Void> {
        return Observable.deferred {
            let realm = self.realm
            return realm.rx.delete(entites)
        }.subscribe(on: self.serialScheduler)
    }
    
}
