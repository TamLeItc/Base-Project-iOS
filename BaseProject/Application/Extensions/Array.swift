//
//  Array.swift
//  BaseProject
//
//  Created by Tam Le on 9/20/20.
//  Copyright © 2020 Tam Le. All rights reserved.
//

import Foundation

extension Array {
    var isNotEmpty: Bool {
        return !isEmpty
    }
    
    func take(_ prefix: Int) -> Self {
        return Array(self.prefix(prefix))
    }
}
