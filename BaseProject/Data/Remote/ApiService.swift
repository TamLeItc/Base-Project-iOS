//
//  ApiService.swift
//  BaseProject
//
//  Created by Tam Le on 31/03/2023.
//

import Foundation
import RxSwift

protocol ApiService {
    func getPost() -> Single<[Post]>
}
