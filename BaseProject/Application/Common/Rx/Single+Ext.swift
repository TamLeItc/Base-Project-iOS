//
//  Single+Ext.swift
//  BaseProject
//
//  Created by Tam Le on 09/07/2021.
//  Copyright © 2021 Tam Le. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension PrimitiveSequence where Trait == SingleTrait {
    func mapToVoid() -> PrimitiveSequence<Trait, Void> {
        return map { _ in }
    }
}
