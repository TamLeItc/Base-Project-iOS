//
//  Reactive.swift
//  i270-locksafe
//
//  Created by Tam Le on 30/03/2023.
//

import Foundation
import Realm
import RealmSwift
import RxSwift

extension Reactive where Base == Realm {
    func save<S: Sequence>(_ objects: S, update: Bool = true) -> Observable<S> where S.Element: Object {
        return Observable.create { observer in
            do {
                try self.base.write {
                    self.base.add(objects.map { $0 }, update: .all)
                }
                observer.onNext(objects)
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
    func save<R: Object>(_ object: R, update: Bool = true) -> Observable<R> {
        return Observable.create { observer in
            do {
                try self.base.write {
                    self.base.add(object, update: .all)
                }
                observer.onNext(object)
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
    func delete<R: ModelConvertibleType>(_ object: R) -> Observable<Void> where R: Object {
        return Observable.create { observer in
            do {
                guard let object = self.base.object(ofType: R.self, forPrimaryKey: object.uid) else { fatalError() }
                try self.base.write {
                    self.base.delete(object)
                }
                observer.onNext(())
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
    func delete<R: ModelConvertibleType>(_ objects: [R]) -> Observable<Void> where R: Object {
        return Observable.create { observer in
            do {
                var temp: [R] = []
                objects.forEach { item in
                    guard let object = self.base.object(ofType: R.self, forPrimaryKey: item.uid) else { fatalError() }
                    temp.append(object)
                    
                }
                try self.base.write {
                    self.base.delete(temp)
                }
                observer.onNext(())
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
}
