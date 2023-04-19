//
//  Networking.swift
//  BaseProject
//
//  Created by Tam Le on 09/07/2021.
//  Copyright © 2021 Tam Le. All rights reserved.
//


import Foundation
import Moya
import RxSwift
import Alamofire
import ObjectMapper

class AppNetworkImp: AppNetwork {
    
    let provider: NetworkProvider<AppApi>
    
    init() {
        let loggingPlugin = NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
        provider = NetworkProvider(session: NetworkConfig.shared, plugins: [loggingPlugin])
    }
    
    func requestWithoutMapping(_ target: AppApi) -> Single<Moya.Response> {
        return provider.request(target)
            .observe(on: MainScheduler.instance)
    }
    
    func request(_ target: AppApi) -> Single<Any> {
        return provider.request(target)
            .mapJSON()
            .observe(on: MainScheduler.instance)
    }
    
    func requestObject<T: BaseMappable>(_ target: AppApi, type: T.Type) -> Single<T> {
        return provider.request(target)
            .mapJSON()
            .map { Mapper<T>().map(JSONObject: $0) }
            .observe(on: MainScheduler.instance)
            .flatMap {
                if let map = $0 {
                    return Single.just(map)
                } else {
                    return Single.error(NSError(domain: "Map object failed", code: 1, userInfo: nil))
                }
            }
    }
    
    func requestArray<T: BaseMappable>(_ target: AppApi, type: T.Type) -> Single<[T]> {
        return provider.request(target)
            .mapJSON()
            .map { Mapper<T>().mapArray(JSONObject: $0) }
            .observe(on: MainScheduler.instance)
            .flatMap {
                if let map = $0 {
                    return Single.just(map)
                } else {
                    return Single.error(NSError(domain: "Map object failed", code: 1, userInfo: nil))
                }
            }
    }
}
