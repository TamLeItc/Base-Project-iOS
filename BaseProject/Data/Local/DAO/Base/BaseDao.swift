//
//  BaseDao.swift
//  BaseProject
//
//  Created by Tam Le on 18/07/2021.
//  Copyright © 2021 Tam Le. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
import RxSwift
import RxRealm

class BaseDAO: BaseDaoService {

    var config: Realm.Configuration
    let concurrentScheduler: ConcurrentDispatchQueueScheduler
    let serialScheduler: SerialDispatchQueueScheduler

    required init(config: Realm.Configuration) {
        self.config = config
        
        let concurrentQueue = DispatchQueue.main
        concurrentScheduler = ConcurrentDispatchQueueScheduler(queue: concurrentQueue)
        serialScheduler = SerialDispatchQueueScheduler(queue: concurrentQueue, internalSerialQueueName: "internalSerialQueueName")
    }
    
    
    var realm: Realm {
        guard let realm = try? Realm(configuration: config) else {
            fatalError()
        }
        return realm
    }

    func writeObject(executeCode: () -> ()) {
        do {
            try realm.write {
                executeCode()
            }
        } catch {
            print(error)
        }
    }
}
