//
//  NetworkConfig.swift
//  BaseProject
//
//  Created by Tam Le on 09/07/2021.
//  Copyright © 2021 Tam Le. All rights reserved.
//

import Foundation
import Alamofire
import Moya

class NetworkConfig: Session {
    static let shared: NetworkConfig = {
        let configuration = URLSessionConfiguration.default
        configuration.headers = .default
        configuration.timeoutIntervalForRequest = Configs.Network.networkTimeout // as seconds, you can set your request timeout
        configuration.timeoutIntervalForResource = Configs.Network.networkTimeout // as seconds, you can set your resource timeout
        configuration.requestCachePolicy = .useProtocolCachePolicy
        return NetworkConfig(configuration: configuration, startRequestsImmediately: false)
    }()
}
