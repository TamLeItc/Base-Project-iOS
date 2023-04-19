//
//  PublishData.swift
//  BaseProject
//
//  Created by Tam Le on 8/23/20.
//  Copyright © 2020 Tam Le. All rights reserved.
//

import Foundation
import RxSwift
import Localize

/// PublishData is a wrapper for `PublishSubject`.
///
/// Unlike `PublishSubject` it can't terminate with error or completed.
class PublishData<T>: ObservableType {
    
    private let subject: PublishSubject<T>
    
    ///make sure the data is never nil
    public private(set) var data : T!

    /// Initializes with internal empty subject.
    public init() {
        subject = PublishSubject()
    }
    
    public init(_ initData: T) {
        subject = PublishSubject()
        self.data = initData
    }
    
    public func accept(_ data : T!) {
        self.data = data
        subject.onNext(data)
    }
    
    /// Subscribes observer
    public func subscribe<Observer: ObserverType>(_ observer: Observer) -> Disposable where Observer.Element == T {
        return subject.subscribe(observer)
    }
    
    /// - returns: Canonical interface for push style sequence
    public func asObservable() -> Observable<T> {
        return subject.asObservable()
    }
    
    public func dispose() {
        subject.dispose()
    }
}
